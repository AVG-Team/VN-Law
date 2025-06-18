from transformers import AutoTokenizer, AutoModelForQuestionAnswering
import torch
import torch.nn.functional as F
import re
import uuid  # Missing import
from app.services.rag_service import RAGService
from app.services.conversation_service import ConversationService
from app.services.messsage_service import MessageService
from app.services.embedding_service import EmbeddingService  # Assuming this is defined elsewhere
import time
import logging

embedding_service = EmbeddingService() 
rag_service = RAGService(embedding_service=embedding_service, use_cpu=False)
conversation_service = ConversationService()
message_service = MessageService()

class LLMService:

    def __init__(self):
        self.model_name = "huynguyen251/phobert-legal-qa-v2"
        self.tokenizer = None
        self.model = None
    
    def connection_hugging_face(self):
        """
        Connects to the Hugging Face Hub and loads model and tokenizer.
        """
        try:
            self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
            self.model = AutoModelForQuestionAnswering.from_pretrained(self.model_name)
            logging.info("Connection to Hugging Face established successfully.")
        except Exception as e:
            logging.error(f"Failed to connect to Hugging Face: {e}")
            raise        

    def process_answer(self, answer: str) -> str:
        """
        Processes the answer by removing leading and trailing whitespace.
        
        :param answer: The answer to be processed.
        :return: The processed answer.
        """
        if not answer:
            return ""
        
        # Remove special tokens
        for bad_token in ["<s>", "</s>", "<pad>", "<unk>", "<mask>", "<cls>", "<sep>", "@@"]:
            answer = answer.replace(bad_token, "")
        
        # Clean up unwanted characters but keep Vietnamese characters
        answer = re.sub(r'[^\w\sÀ-ỹ/\-().,!?:]', '', answer)
        
        # Remove extra whitespace
        answer = re.sub(r'\s+', ' ', answer)
        answer = answer.strip()
        return answer

    def create_conversation(self, user_id: str, context: str = None) -> int:
        """Creates a new conversation and returns its ID."""
        try:
            conversation = conversation_service.create_conversation(user_id, context)
            logging.info(f"Conversation created with ID: {conversation.conversation_id}")
            return conversation.conversation_id
        except Exception as e:
            logging.error(f"Failed to create conversation: {e}")
            raise

    def end_conversation(self, conversation_id: int) -> None:
        """Ends a conversation."""
        try:
            conversation_service.end_conversation(conversation_id)
            logging.info(f"Conversation {conversation_id} ended.")
        except Exception as e:
            logging.error(f"Failed to end conversation {conversation_id}: {e}")
    
    def create_message(self, conversation_id: int, user_id: str, content: str) -> None:
        """Creates a user message."""
        try:
            message_service.create_message(conversation_id, user_id, content)
            logging.info(f"Message created in conversation {conversation_id} by user {user_id}.")
        except Exception as e:
            logging.error(f"Failed to create message: {e}")
    
    def create_answer_message(self, conversation_id: int, user_id: str, content: str) -> None:
        """Creates a bot answer message."""
        try:
            message_service.create_message(conversation_id, user_id, content, sender='bot')
            logging.info(f"Answer message created in conversation {conversation_id} by bot.")
        except Exception as e:
            logging.error(f"Failed to create answer message: {e}")

    def answer_question(self, question: str, threshold: float = 0.7) -> str:
        """
        Answers a question using the QA model and RAG system.
        
        :param question: The question to answer
        :param threshold: Confidence threshold for accepting answers
        :return: The answer string
        """
        try:
            # Load model if not already loaded
            if self.model is None or self.tokenizer is None: 
                logging.info("Connecting to Hugging Face model...")
                self.connection_hugging_face()
            
            # Check question length
            if len(question) > 512: 
                return "Câu hỏi quá dài, vui lòng rút gọn lại."
            
            # Retrieve relevant documents
            start_time = time.time()
            retrieved_docs = rag_service.retrieve_documents(question)
            retrieve_time = time.time() - start_time
            logging.info(f"Retrieve time: {retrieve_time:.2f}s")
            
            # Extract context from retrieved documents
            context = ""
            if retrieved_docs.get("documents") and retrieved_docs["documents"][0]:
                context = " ".join(retrieved_docs["documents"][0])
            else:
                context = "Không có tài liệu liên quan."
            
            # Tokenize input
            inputs = self.tokenizer.encode_plus(
                question,
                context,
                return_tensors='pt',
                truncation=True,
                max_length=512,  # Add explicit max_length
                padding=True
            )
            
            # Get model predictions
            start_time = time.time()
            with torch.no_grad():
                output = self.model(**inputs)
                start_scores = output.start_logits
                end_scores = output.end_logits
            
            inference_time = time.time() - start_time
            logging.info(f"Inference time: {inference_time:.2f}s")
            
            # Calculate probabilities and find best span
            start_probs = F.softmax(start_scores, dim=1)
            end_probs = F.softmax(end_scores, dim=1)

            start_index = torch.argmax(start_probs).item()
            end_index = torch.argmax(end_probs).item() + 1

            # Ensure valid span
            if end_index <= start_index:
                end_index = start_index + 1

            # Calculate confidence score
            confidence = (start_probs[0][start_index] * end_probs[0][end_index - 1]).item()
            logging.info(f"Confidence score: {confidence:.4f}")

            # Extract answer tokens
            answer_tokens = inputs['input_ids'][0][start_index:end_index]
            answer = self.tokenizer.decode(answer_tokens, skip_special_tokens=True)
            answer = self.process_answer(answer)

            # Check confidence threshold
            if confidence < threshold:
                return "Không có thông tin liên quan đến câu hỏi của bạn."
            
            # Save conversation if confidence is high enough
            if answer and len(answer.strip()) > 0:  # Only save if we have a meaningful answer
                user_uuid = str(uuid.uuid4())
                conversation_id = self.create_conversation(user_id=user_uuid, context=context)
                self.create_message(conversation_id=conversation_id, user_id=user_uuid, content=question)
                self.create_answer_message(conversation_id=conversation_id, user_id=user_uuid, content=answer)
                logging.info("Conversation and messages saved successfully.")
            
            return answer
            
        except Exception as e:
            logging.error(f"Error in answer_question: {e}")
            return "Đã xảy ra lỗi khi xử lý câu hỏi của bạn. Vui lòng thử lại."