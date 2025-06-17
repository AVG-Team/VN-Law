from flask import Flask, request, jsonify
import logging
import time
import redis
import json
from transformers import pipeline
from typing import List
import torch
from app.services.embedding_service import EmbeddingService
from sentence_transformers import CrossEncoder


logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

class RAGService:
    _instance = None

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(
        self,
        embedding_service: EmbeddingService,
        generator_model: str = "VietAI/gpt-neo-1.3B-vietnamese-news",
        cross_encoder_model: str = "cross-encoder/ms-marco-MiniLM-L-6-v2",
        top_k: int =  3,
        use_cpu: bool = False,  # Add option to force CPU usage
    ):
        if hasattr(self, 'initialized'):
            return
        self.initialized = True
        
        # Force CPU if requested or if CUDA causes issues
        self.device = "cpu" if use_cpu else ("cuda" if torch.cuda.is_available() else "cpu")
        self.embedding_service = embedding_service
        
        try:
            # Try to initialize with more conservative settings
            self.llm_pipeline = pipeline(
                "text-generation",
                model=generator_model,
                device=0 if self.device == "cuda" else -1,
                max_new_tokens=128,
                do_sample=False,
                pad_token_id=0,  # Explicitly set pad_token_id
                truncation=True,
                model_kwargs={
                    "torch_dtype": torch.float16 if self.device == "cuda" else torch.float32,
                    "low_cpu_mem_usage": True,
                }
            )
            
            # Initialize the CrossEncoder with error handling
            self.cross_encoder = CrossEncoder(cross_encoder_model, device=self.device)
            
        except Exception as e:
            logging.warning(f"Failed to initialize on {self.device}, falling back to CPU: {e}")
            self.device = "cpu"
            self.llm_pipeline = pipeline(
                "text-generation",
                model=generator_model,
                device=-1,
                max_new_tokens=128,
                do_sample=False,
                pad_token_id=0,
                truncation=True,
            )
            self.cross_encoder = CrossEncoder(cross_encoder_model, device="cpu")
        
        self.cache = redis.Redis(host='14.225.218.42', port=6379, db=0)
        self.top_k = top_k

    def preprocess_text(self, text: str) -> str:
        return self.embedding_service.preprocess_text(text)

    def rerank_documents(self, query: str, documents: List[str]) -> List[str]:
        """Rerank documents based on relevance to the query using CrossEncoder."""
        if not documents:
            return []
        
        try:
            # Limit document length to prevent memory issues
            max_doc_length = 512
            truncated_docs = [doc[:max_doc_length] for doc in documents]
            
            pairs = [[query, doc] for doc in truncated_docs]
            scores = self.cross_encoder.predict(pairs)
            reranked_docs = [doc for _, doc in sorted(zip(scores, documents), reverse=True)]
            return reranked_docs
        except Exception as e:
            logging.warning(f"Error in reranking, returning original order: {e}")
            return documents
    
    def retrieve_documents(self, query: str) -> dict:
        query = self.preprocess_text(query)
        cache_key = f"query:{query}"
        cached = self.cache.get(cache_key)
        if cached:
            return json.loads(cached)
        query_embedding = self.embedding_service.sentence_transformer.encode(query, convert_to_numpy=True).tolist()
        results = self.embedding_service.collection.query(query_embeddings=[query_embedding], n_results=self.top_k)
        if results["documents"] and results["documents"][0]:
                documents = results["documents"][0]
                reranked_docs = self.rerank_documents(query, documents)
                results["documents"][0] = reranked_docs
        self.cache.setex(cache_key, 3600, json.dumps(results))
        return results

    def generate_answer(self, query: str) -> str:
        try:
            if len(query) > 500:
                return "Câu hỏi quá dài, vui lòng rút ngắn."
            start_time = time.time()
            retrieved_docs = self.retrieve_documents(query)
            logging.info(f"Retrieve time: {time.time() - start_time:.2f}s")
            
            docs_text = " ".join(retrieved_docs["documents"][0]) if retrieved_docs["documents"] and \
                                                                    retrieved_docs["documents"][0] else "Không có tài liệu liên quan."
            
            # Truncate docs_text to prevent memory issues
            max_context_length = 1000  # Limit context length
            if len(docs_text) > max_context_length:
                docs_text = docs_text[:max_context_length] + "..."
            
            prompt = f"""Bạn là một trợ lý pháp lý chuyên nghiệp, am hiểu luật pháp Việt Nam. Dựa trên các tài liệu sau, trả lời câu hỏi một cách ngắn gọn, chính xác và rõ ràng bằng tiếng Việt. Nếu không có thông tin liên quan, hãy trả lời "Không tìm thấy thông tin phù hợp."
            Câu hỏi: {query}
            Tài liệu: {docs_text}
            Trả lời: """
            
            # Clear CUDA cache before inference to prevent memory issues
            if self.device == "cuda":
                torch.cuda.empty_cache()
            
            response = self.llm_pipeline(
                prompt,
                max_new_tokens=128,
                do_sample=False,
                num_return_sequences=1,
                truncation=True,
                max_length=1024,  # Set max_length to prevent overflow
                return_full_text=False,  # Only return generated text
            )[0]["generated_text"]
            
            logging.info(f"LLM time: {time.time() - start_time:.2f}s")
            
            # Clean up the response
            answer = response.replace(prompt, "").strip()
            if not answer:
                answer = "Không tìm thấy thông tin phù hợp."
                
            logging.info(f"Query: {query}\nAnswer: {answer}")
            return answer
            
        except Exception as e:
            logging.error(f"Error generating answer: {e}")
            # Clear CUDA cache on error
            if self.device == "cuda":
                torch.cuda.empty_cache()
            return "Đã xảy ra lỗi khi sinh câu trả lời."

    def generate_answer_batch(self, queries: List[str]) -> List[str]:
        prompts = []
        for query in queries:
            docs = self.retrieve_documents(query)
            if docs is None or not docs.get("documents"):
               docs_text = "Không có tài liệu liên quan."
            else:
                # Fixed the join issue - should join the documents list
                docs_text = " ".join(docs["documents"][0]) if docs["documents"][0] else "Không có tài liệu liên quan."
                logging.info(f"Retrieved documents for query '{query}': {docs_text}")
            
            prompt = f"""Bạn là một trợ lý pháp lý chuyên nghiệp, am hiểu luật pháp Việt Nam. Dựa trên các tài liệu sau, trả lời câu hỏi một cách ngắn gọn, chính xác và rõ ràng bằng tiếng Việt. Nếu không có thông tin liên quan, hãy trả lời "Không tìm thấy thông tin phù hợp."
            Câu hỏi: {query}
            Tài liệu: {docs_text}
            Trả lời: """
            prompts.append(prompt)
        responses = self.llm_pipeline(prompts, max_new_tokens=128, do_sample=False)
        return [resp["generated_text"].replace(prompt, "").strip() for prompt, resp in zip(prompts, responses)]

# app = Flask(__name__)

# embedding_service = EmbeddingService()

# rag_service = RAGService(embedding_service=embedding_service, use_cpu=False)

# @app.route('/query', methods=['POST'])
# def query_endpoint():
#     start_time = time.time()
#     data = request.get_json()
#     query = data.get('query', '')
#     if not query:
#         return jsonify({"error": "Query is required"}), 400
#     answer = rag_service.generate_answer(query)
#     return jsonify({
#         "answers": answer,
#         "time_taken": time.time() - start_time
#     })

# @app.route('/query_batch', methods=['POST'])
# def query_batch_endpoint():
#     start_time = time.time()
#     data = request.get_json()
#     queries = data.get('queries', [])
#     if not queries:
#         return jsonify({"error": "Queries list is required"}), 400
#     answers = rag_service.generate_answer_batch(queries)
#     return jsonify({
#         "answers": answers,
#         "time_taken": time.time() - start_time
#     })

# @app.route('/retrieve', methods=['POST'])
# def retrieve_endpoint():
#     start_time = time.time()
#     data = request.get_json()
#     query = data.get('query', '')
#     if not query:
#         return jsonify({"error": "Query is required"}), 400
#     answers = rag_service.retrieve_documents(query)
#     return jsonify({
#         "answers": answers,
#         "time_taken": time.time() - start_time
#     })

# if __name__ == '__main__':
#     from waitress import serve
#     serve(app, host='0.0.0.0', port=8000, threads=8)