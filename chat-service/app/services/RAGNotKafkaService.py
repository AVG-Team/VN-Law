import os
import uuid

import torch
from chromadb.utils.embedding_functions.sentence_transformer_embedding_function import SentenceTransformerEmbeddingFunction
from dotenv import load_dotenv
from sentence_transformers import SentenceTransformer
from sentence_transformers.cross_encoder import CrossEncoder
from transformers import pipeline
import chromadb
from underthesea import text_normalize
import logging
from typing import List, Dict, Optional
import mysql.connector

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

class RAGNotKafkaService:
    def __init__(
            self,
            embedding_model: str = "bkai-foundation-models/vietnamese-bi-encoder",
            generator_model: str = "vinai/PhoGPT-4B-Chat",
            top_k: int = 5,
            chroma_host: str = "localhost",
            chroma_port: int = 8000,
            hf_token: str = None,
    ):
        """
        Initialize RAGService for document embedding and retrieval-augmented generation.

        Args:
            embedding_model (str): Name of the embedding model.
            generator_model (str): Name of the generative model.
            top_k (int): Number of documents to retrieve.
            chroma_host (str): ChromaDB host.
            chroma_port (int): ChromaDB port.
            hf_token (str): Hugging Face token for private models.
        """
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        logging.info(f"Using device: {self.device}")
        # Load embedding model
    
        try:
            self.sentence_transformer = SentenceTransformer(embedding_model)
        except Exception as e:
            logging.error(f"Error loading embedding model: {e}")
            raise

        # Load cross-encoder for reranking
        try:
            self.cross_encoder = CrossEncoder("cross-encoder/ms-marco-MiniLM-L-6-v2")
        except Exception as e:
            logging.error(f"Error loading cross-encoder: {e}")
            raise

        # Load LLM pipeline
        try:
            self.llm_pipeline = pipeline(
                "text-generation",
                model=generator_model,
                tokenizer=generator_model,
                device=0 if self.device == "cuda" else -1,
                max_length=256,
                token=hf_token,
            )
        except Exception as e:
            logging.warning(f"Error loading {generator_model}: {e}")
            logging.info("Falling back to facebook/xglm-4.5B")
            try:
                self.llm_pipeline = pipeline(
                    "text-generation",
                    model="facebook/xglm-4.5B",
                    tokenizer="facebook/xglm-4.5B",
                    device=0 if self.device == "cuda" else -1,
                    max_length=256,
                    token=hf_token,
                )
            except Exception as e:
                logging.error(f"Error loading fallback model: {e}")
                raise

        # Initialize ChromaDB HTTP client
        try:
            TENANT_NAME = "default_tenant"
            DB_NAME = "default_database"

            self.client = chromadb.HttpClient(
                host=chroma_host,
                port=chroma_port,
                tenant=TENANT_NAME,
                database=DB_NAME,
            )

            # Check if collection exists
            collection_name = "law_documents"
            embedding_function = SentenceTransformerEmbeddingFunction(
                model_name="sentence-transformers/all-MiniLM-L6-v2"
            )
            try:
                self.collection = self.client.get_collection(name=collection_name)
                logging.info(f"Collection '{collection_name}' already exists.")
            except Exception:
                # Collection does not exist, create it
                self.collection = self.client.create_collection(
                    name=collection_name,
                    embedding_function=embedding_function,
                )
                logging.info(f"Created new collection '{collection_name}'.")
        except Exception as e:
            logging.error(f"Error initializing ChromaDB client: {e}")
            raise

        self.top_k = top_k


    def preprocess_text(self, text: str) -> str:
        """Normalize Vietnamese text."""
        if not text:
            return ""
        return text_normalize(text)


    def rerank_documents(self, query: str, documents: List[str]) -> List[str]:
        """Rerank documents based on relevance to the query."""
        if not documents:
            return documents

        pairs = [[query, doc] for doc in documents]
        scores = self.cross_encoder.predict(pairs)
        sorted_docs = [doc for _, doc in sorted(zip(scores, documents), reverse=True)]
        return sorted_docs

    def retrieve_documents(self, query: str) -> Dict:
        """Retrieve relevant documents for a query."""
        query = self.preprocess_text(query)
        query_embedding = self.sentence_transformer.encode(query, convert_to_numpy=True).tolist()
        try:
            results = self.collection.query(
                query_embeddings=[query_embedding],
                n_results=self.top_k,
                where={"source": {"$in": ["mysql_db"]}},
            )
            if results["documents"] and results["documents"][0]:
                documents = results["documents"][0]
                reranked_docs = self.rerank_documents(query, documents)
                results["documents"][0] = reranked_docs
            return results
        except Exception as e:
            logging.error(f"Error retrieving documents: {e}")
            raise

    def generate_answer(self, query: str) -> str:
        """Generate an answer for a query using retrieved documents."""
        try:
            retrieved_docs = self.retrieve_documents(query)
            docs_text = " ".join(retrieved_docs["documents"][0]) if retrieved_docs["documents"] and \
                                                                    retrieved_docs["documents"][
                                                                        0] else "Không có tài liệu liên quan."

            prompt = f"""Bạn là một trợ lý pháp lý chuyên nghiệp, am hiểu luật pháp Việt Nam. Dựa trên các tài liệu sau, trả lời câu hỏi một cách ngắn gọn, chính xác và rõ ràng bằng tiếng Việt. Nếu không có thông tin liên quan, hãy trả lời "Không tìm thấy thông tin phù hợp."

            Câu hỏi: {query}
            Tài liệu: {docs_text}

            Trả lời: """

            response = self.llm_pipeline(
                prompt,
                max_length=512,
                num_return_sequences=1,
                truncation=True,
                temperature=0.7,
            )[0]["generated_text"]

            answer = response.replace(prompt, "").strip()
            logging.info(f"Query: {query}\nAnswer: {answer}")
            return answer
        except Exception as e:
            logging.error(f"Error generating answer: {e}")
            return "Đã xảy ra lỗi khi sinh câu trả lời."

    def get_database_stats(self) -> Dict:
        """Get statistics about the database."""
        connection = None
        try:
            connection = self.get_mysql_connection()
            cursor = connection.cursor(dictionary=True)

            stats = {}

            # Count documents
            cursor.execute("SELECT COUNT(*) as count FROM vbqppl WHERE content IS NOT NULL")
            stats['total_documents'] = cursor.fetchone()['count']

            # Count articles
            cursor.execute("SELECT COUNT(*) as count FROM pdarticle WHERE content IS NOT NULL")
            stats['total_articles'] = cursor.fetchone()['count']

            # Count chapters
            cursor.execute("SELECT COUNT(*) as count FROM pdchapter")
            stats['total_chapters'] = cursor.fetchone()['count']

            # Count subjects
            cursor.execute("SELECT COUNT(*) as count FROM pdsubject")
            stats['total_subjects'] = cursor.fetchone()['count']

            # Count topics
            cursor.execute("SELECT COUNT(*) as count FROM pdtopic")
            stats['total_topics'] = cursor.fetchone()['count']

            return stats
        except mysql.connector.Error as e:
            logging.error(f"Error getting database stats: {e}")
            return {}
        finally:
            if connection and connection.is_connected():
                cursor.close()
                connection.close()

# Example usage
if __name__ == '__main__':
    load_dotenv()
    # Initialize RAG service with MySQL
    rag_service = RAGNotKafkaService(
        chroma_host="localhost",
        chroma_port=8000,
        mysql_host="localhost",
        mysql_port=3306,
        mysql_user="root",
        mysql_password="password",
        mysql_database="law_service",
        hf_token=os.getenv("HF_TOKEN")  # Uncomment if needed
    )

    # Get database statistics
    stats = rag_service.get_database_stats()
    print("Database Statistics:")
    for key, value in stats.items():
        print(f"  {key}: {value}")

    # rag_service.embed_documents_from_db(load_type="articles")
    rag_service.embed_documents_from_db(load_type="documents", limit=10)