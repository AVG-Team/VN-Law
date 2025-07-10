from transformers import AutoTokenizer, AutoModelForQuestionAnswering
import torch
import torch.nn.functional as F
import re
import uuid
import time
import logging
from typing import Dict, Any, Union, Optional, List
from dataclasses import dataclass
from contextlib import contextmanager
import os

from app.services.chat_service import ChatbotService
from app.services.rag_service import RAGService
from app.services.conversation_service import ConversationService
from app.services.messsage_service import MessageService
from app.services.embedding_service import EmbeddingService

os.environ["CUDA_LAUNCH_BLOCKING"] = "1"
@dataclass
class QAResult:
    """Data class for QA results"""
    answer: str
    context: str
    confidence: float
    meets_threshold: bool
    processing_time: float


class LLMServiceConfig:
    """Configuration class for LLM Service"""
    MODEL_NAME = "huynguyen251/phobert-legal-qa-v2"
    MAX_QUESTION_LENGTH = 256
    MAX_CONTEXT_LENGTH = 256
    MAX_ANSWER_LENGTH = 100
    DEFAULT_THRESHOLD = 0.7
    
    # Special tokens to remove
    BAD_TOKENS = ["<s>", "</s>", "<pad>", "<unk>", "<mask>", "<cls>", "<sep>", "@@"]
    
    # Vietnamese character regex pattern
    CLEAN_PATTERN = r'[^\w\sÀ-ỹ/\-().,!?:]'


class LLMService:    
    def __init__(self, config: Optional[LLMServiceConfig] = None):
        
        self.config = config or LLMServiceConfig()
        self.model_name = self.config.MODEL_NAME
        self.tokenizer = None
        self.model = None
        self._model_loaded = False
        
        # Initialize services
        self._initialize_services()
        
        # Setup logging
        self._setup_logging()
    
    def _initialize_services(self) -> None:
        try:
            self.embedding_service = EmbeddingService()
            self.rag_service = RAGService(
                embedding_service=self.embedding_service, 
                use_cpu=False
            )
            self.conversation_service = ConversationService()
            self.message_service = MessageService()
            self.chat_service = ChatbotService()
            
            logging.info("External services initialized successfully")
            
        except Exception as e:
            logging.error(f"Failed to initialize services: {e}")
            raise RuntimeError(f"Service initialization failed: {e}")
    
    def _setup_logging(self) -> None:
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
    
    @contextmanager
    def _timer(self, operation_name: str):
        start_time = time.time()
        try:
            yield start_time
        finally:
            elapsed_time = time.time() - start_time
            logging.info(f"{operation_name} completed in {elapsed_time:.2f}s")
    
    def connection_hugging_face(self) -> bool:
        try:
            with self._timer("Model loading"):
                logging.info(f"Loading model: {self.model_name}")
                
                # Load tokenizer
                self.tokenizer = AutoTokenizer.from_pretrained(
                    self.model_name,
                    use_fast=True,
                    trust_remote_code=True
                )
                
                # Load model
                self.model = AutoModelForQuestionAnswering.from_pretrained(
                    self.model_name,
                    trust_remote_code=True,
                    torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32
                )
                
                # Move to GPU if available
                if torch.cuda.is_available():
                    self.model = self.model.cuda()
                    logging.info("Model moved to GPU")
                
                self._model_loaded = True
                logging.info("Hugging Face connection established successfully")
                return True
                
        except Exception as e:
            logging.error(f"Failed to connect to Hugging Face: {e}")
            self._model_loaded = False
            return False
    
    def _ensure_model_loaded(self) -> bool:
        if not self._model_loaded or self.model is None or self.tokenizer is None:
            return self.connection_hugging_face()
        return True
    
    def process_answer(self, answer: str) -> str:
        if not answer or not isinstance(answer, str):
            return ""
        
        # Remove special tokens
        for bad_token in self.config.BAD_TOKENS:
            answer = answer.replace(bad_token, "")
        
        # Clean up unwanted characters but preserve Vietnamese characters
        answer = re.sub(self.config.CLEAN_PATTERN, '', answer)
        
        # Remove extra whitespace
        answer = re.sub(r'\s+', ' ', answer)
        answer = answer.strip()
        
        # Remove leading/trailing punctuation if it doesn't make sense
        answer = re.sub(r'^[^\w\sÀ-ỹ]+|[^\w\sÀ-ỹ.!?]+$', '', answer)
        
        return answer
    
    def create_conversation(self, user_id: str, conversation_id:str, context: str = None) -> str:
        try:
            conversation_exists = self.conversation_service.get_conversation_by_id(conversation_id)
            if conversation_exists:
                logging.info(f"Conversation {conversation_id} already exists")
                self.conversation_service.end_conversation(conversation_id)
                return conversation_id

            conversation = self.conversation_service.create_conversation(user_id, conversation_id, context)
            conversation_id = conversation.conversation_id
            logging.info(f"Conversation created with ID: {conversation_id}")
            return conversation_id
            
        except Exception as e:
            logging.error(f"Failed to create conversation: {e}")
            raise RuntimeError(f"Conversation creation failed: {e}")
    
    def end_conversation(self, conversation_id: int) -> bool:
        try:
            self.conversation_service.end_conversation(conversation_id)
            logging.info(f"Conversation {conversation_id} ended successfully")
            return True
            
        except Exception as e:
            logging.error(f"Failed to end conversation {conversation_id}: {e}")
            return False

    def create_message(self, conversation_id: str, user_id: str, question:str, content: str, context:str) -> bool:
        try:
            self.message_service.create_message(
                conversation_id=conversation_id, user_id=user_id,
                question=question, content=content, context=context
            )
            logging.info(f"User message created in conversation {conversation_id}")
            return True
            
        except Exception as e:
            logging.error(f"Failed to create message: {e}")
            return False

    def _validate_question(self, question: str) -> str:
        if not question or not isinstance(question, str):
            raise ValueError("Question must be a non-empty string")
        
        question = question.strip()
        if not question:
            raise ValueError("Question cannot be empty")
        
        if len(question) > self.config.MAX_QUESTION_LENGTH:
            raise ValueError(f"Question too long (max {self.config.MAX_QUESTION_LENGTH} characters)")
        
        return question
    
    def _retrieve_context(self, question: str) -> dict[str, str | list[Any]] | dict[str, str | list[Any]] | dict[
        str, str | list[Any]]:
        url_relate = []
        try:
            with self._timer("Document retrieval"):
                retrieved_docs = self.rag_service.retrieve_documents(question)

            print("Retrieved documents:", retrieved_docs)
            logging.info(retrieved_docs)

            if (retrieved_docs.get("metadatas") and
                    retrieved_docs["metadatas"] and
                    retrieved_docs["metadatas"][0]):
                metadatas = retrieved_docs["metadatas"][0]
                print("Retrieved metadatas:")
                print(metadatas)
                url_relate = [meta.get('vbqppl_link', '') for meta in metadatas]
                print("Related URLs:", url_relate)

            
            # Extract and combine context
            if (retrieved_docs.get("documents") and 
                retrieved_docs["documents"] and 
                retrieved_docs["documents"][0]):
                
                context = " ".join(retrieved_docs["documents"][0])
                
                # Truncate context if too long
                if len(context) > self.config.MAX_CONTEXT_LENGTH * 4:  # Rough character estimate
                    context = context[:self.config.MAX_CONTEXT_LENGTH * 4]
                    logging.warning("Context truncated due to length")

                return {
                    'documents': context.strip(),
                    'url_relate': url_relate,
                }
            else:
                return {
                    'documents': "Không có tài liệu liên quan.",
                    'url_relate': url_relate
                }
                
        except Exception as e:
            logging.error(f"Error retrieving context: {e}")
            return {
                'documents': "Không thể tìm kiếm tài liệu liên quan.",
                'url_relate': url_relate
            }
    
    def _generate_answer(self, question: str, context: str, threshold: float) -> QAResult:
        start_time = time.time()
        
        try:
            # Tokenize input
            inputs = self.tokenizer.encode_plus(
                question,
                context,
                return_tensors='pt',
                truncation=True,
                max_length=self.config.MAX_CONTEXT_LENGTH,
                padding=True,
                return_attention_mask=True,
                return_token_type_ids=True
            )
            
            # Move to GPU if available
            if torch.cuda.is_available() and self.model.device.type == 'cuda':
                inputs = {k: v.cuda() for k, v in inputs.items()}
            
            # Model inference
            with torch.no_grad():
                with self._timer("Model inference"):
                    outputs = self.model(**inputs)
                    start_logits = outputs.start_logits
                    end_logits = outputs.end_logits
            
            # Find best answer span
            answer_info = self._find_best_answer_span(start_logits, end_logits)
            
            # Calculate confidence
            confidence = self._calculate_confidence(
                start_logits, end_logits, answer_info['start'], answer_info['end']
            )
            
            # Extract and process answer
            answer = self._extract_answer(inputs['input_ids'], answer_info)
            
            processing_time = time.time() - start_time
            meets_threshold = confidence >= threshold
            
            if not meets_threshold:
                answer = "Không có thông tin liên quan đến câu hỏi của bạn."
            
            return QAResult(
                answer=answer,
                context=context,
                confidence=confidence,
                meets_threshold=meets_threshold,
                processing_time=processing_time
            )
            
        except Exception as e:
            logging.error(f"Error in answer generation: {e}")
            processing_time = time.time() - start_time
            return QAResult(
                answer="Không thể tạo câu trả lời. Vui lòng thử lại.",
                context=context,
                confidence=0.0,
                meets_threshold=False,
                processing_time=processing_time
            )
    
    def _find_best_answer_span(self, start_logits: torch.Tensor, 
                              end_logits: torch.Tensor) -> Dict[str, int]:
        # Convert to probabilities
        start_probs = F.softmax(start_logits, dim=1)
        end_probs = F.softmax(end_logits, dim=1)
        
        # Find best positions
        start_idx = torch.argmax(start_probs, dim=1).item()
        end_idx = torch.argmax(end_probs, dim=1).item()
        
        # Ensure valid span
        if end_idx <= start_idx:
            end_idx = start_idx + 1
        
        # Limit answer length
        if end_idx - start_idx > self.config.MAX_ANSWER_LENGTH:
            end_idx = start_idx + self.config.MAX_ANSWER_LENGTH
        
        return {"start": start_idx, "end": end_idx}
    
    def _calculate_confidence(self, start_logits: torch.Tensor, end_logits: torch.Tensor,
                             start_idx: int, end_idx: int) -> float:
        try:
            start_probs = F.softmax(start_logits, dim=1)
            end_probs = F.softmax(end_logits, dim=1)
            
            start_prob = start_probs[0][start_idx].item()
            end_prob = end_probs[0][end_idx].item()
            
            # Geometric mean for more conservative confidence
            confidence = (start_prob * end_prob) ** 0.5
            
            return min(max(confidence, 0.0), 1.0)  # Clamp between 0 and 1
            
        except Exception as e:
            logging.error(f"Error calculating confidence: {e}")
            return 0.0
    
    def _extract_answer(self, input_ids: torch.Tensor, 
                       answer_span: Dict[str, int]) -> str:
        try:
            # Extract answer tokens
            answer_tokens = input_ids[0][answer_span["start"]:answer_span["end"]]
            
            # Decode tokens
            raw_answer = self.tokenizer.decode(answer_tokens, skip_special_tokens=True)
            
            # Process answer
            processed_answer = self.process_answer(raw_answer)
            
            return processed_answer
            
        except Exception as e:
            logging.error(f"Error extracting answer: {e}")
            return "Không thể trích xuất câu trả lời."
    
    def _save_conversation(self, user_uuid: str, conversation_id:str, question: str, answer: str, context: str) -> bool:
        try:
            # Create conversation
            conversation_id = self.create_conversation(user_id=user_uuid, conversation_id=conversation_id , context=question)

            # Save question and answer
            question_saved = self.create_message(conversation_id, user_uuid, question, answer, context)

            if question_saved :
                logging.info(f"Conversation saved successfully with ID: {conversation_id}")
                return True
            else:
                logging.warning("Failed to save some conversation messages")
                return False
                
        except Exception as e:
            logging.error(f"Error saving conversation: {e}")
            return False
    
    def answer_question(self, user_id: str, question: str, conversation_id: str,
                       threshold: float = None) -> Union[str, Dict[str, Any]]:
        if threshold is None:
            threshold = self.config.DEFAULT_THRESHOLD
        
        try:
            # Validate input
            question = self._validate_question(question)
            
            # Ensure model is loaded
            if not self._ensure_model_loaded():
                raise RuntimeError("Failed to load model")
            
            # Retrieve context
            context = self._retrieve_context(question)
            print("context", context['documents'])
            
            # Generate answer
            result = self._generate_answer(question, context['documents'], threshold)
            print("result", result)
            # GPT
            answer_gpt = self.chat_service.generate_response(result.context, question, result.answer, context['url_relate'])
            # Save conversation if answer is valid and meets threshold
            if result.answer.strip():
                save_success = self._save_conversation(user_id, conversation_id, question, answer_gpt, context['documents'])
                if not save_success:
                    logging.warning("Failed to save conversation, but continuing with answer")

            # Check if answer is wrong or empty
            if not result.answer.strip() or answer_gpt.startswith("Xin lỗi"):
                return {
                    "answer": answer_gpt,
                    "context": "",
                    "confidence": result.confidence,
                    "meets_threshold": False,
                    "processing_time": result.processing_time,
                    "url_relate": []
                }
            # Process url
            if not result.meets_threshold:
                context['url_relate'] = []

            # Return detailed result
            return {
                "answer": answer_gpt,
                "context": result.context,
                "confidence": result.confidence,
                "meets_threshold": result.meets_threshold,
                "processing_time": result.processing_time,
                "url_relate": context['url_relate'] if 'url_relate' in context else []
            }
            
        except ValueError as e:
            logging.error(f"Validation error: {e}")
            return str(e)
            
        except RuntimeError as e:
            logging.error(f"Runtime error: {e}")
            return "Không thể tải mô hình. Vui lòng thử lại sau."
            
        except Exception as e:
            logging.error(f"Unexpected error in answer_question: {e}")
            return "Đã xảy ra lỗi khi xử lý câu hỏi của bạu. Vui lòng thử lại."
    
    def get_model_info(self) -> Dict[str, Any]:
        return {
            "model_name": self.model_name,
            "model_loaded": self._model_loaded,
            "device": str(self.model.device) if self.model else "Not loaded",
            "config": {
                "max_question_length": self.config.MAX_QUESTION_LENGTH,
                "max_context_length": self.config.MAX_CONTEXT_LENGTH,
                "max_answer_length": self.config.MAX_ANSWER_LENGTH,
                "default_threshold": self.config.DEFAULT_THRESHOLD
            }
        }
    
    def health_check(self) -> Dict[str, Any]:

        try:
            model_ok = self._ensure_model_loaded()
            services_ok = all([
                self.rag_service is not None,
                self.conversation_service is not None,
                self.message_service is not None,
                self.embedding_service is not None
            ])
            
            return {
                "status": "healthy" if (model_ok and services_ok) else "unhealthy",
                "model_loaded": model_ok,
                "services_initialized": services_ok,
                "gpu_available": torch.cuda.is_available(),
                "timestamp": time.time()
            }
            
        except Exception as e:
            return {
                "status": "unhealthy",
                "error": str(e),
                "timestamp": time.time()
            }