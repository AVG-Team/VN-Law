import logging
import json
import re
import uuid
import numpy as np
import torch
from kafka import KafkaConsumer, KafkaProducer
from sentence_transformers import SentenceTransformer
from sentence_transformers.cross_encoder import CrossEncoder
from transformers import pipeline
import chromadb
from underthesea import sent_tokenize, text_normalize

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

class RAGService:
    def __init__(
        self,
        embedding_model: str = "bkai-foundation-models/vietnamese-bi-encoder",
        generator_model: str = "vinai/PhoGPT-7B-Instruct",
        kafka_topic: str = "law-document",
        bootstrap_servers: str = "localhost:9092",
        group_id: str = "rag-service-group",
        top_k: int = 5,
    ):
        """
        Initialize RAGService for document embedding and retrieval-augmented generation.

        Args:
            embedding_model (str): Name of the embedding model.
            generator_model (str): Name of the generative model.
            kafka_topic (str): Kafka topic to consume messages from.
            bootstrap_servers (str): Kafka bootstrap servers.
            group_id (str): Kafka consumer group ID.
            top_k (int): Number of documents to retrieve.
        """
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        logging.info(f"Using device: {self.device}")

        # Load embedding model
        self.sentence_transformer = SentenceTransformer(embedding_model)

        # Load cross-encoder for reranking
        self.cross_encoder = CrossEncoder("cross-encoder/ms-marco-MiniLM-L-6-v2")

        # Load LLM pipeline
        self.llm_pipeline = pipeline(
            "text-generation",
            model=generator_model,
            tokenizer=generator_model,
            device=0 if self.device == "cuda" else -1,
            max_length=512,
        )

        # Initialize ChromaDB
        self.client = chromadb.PersistentClient(path="chroma_db")
        self.collection = self.client.get_or_create_collection(
            name="law_documents",
            embedding_function=self.sentence_transformer.encode,
        )
        self.top_k = top_k

        # Initialize Kafka producer for error handling
        self.producer = KafkaProducer(bootstrap_servers=bootstrap_servers)
        self.error_topic = "error-messages"

        # Store Kafka configuration for processing
        self.kafka_config = {
            "topic": kafka_topic,
            "bootstrap_servers": bootstrap_servers,
            "group_id": group_id,
        }

    def preprocess_text(self, text: str) -> str:
        """
        Normalize Vietnamese text.

        Args:
            text (str): Input text.

        Returns:
            str: Normalized text.
        """
        return text_normalize(text)

    def chunk_by_law_structure(self, text: str, chunk_size: int = 512, overlap: int = 50) -> list[str]:
        """
        Split text into chunks based on law structure.

        Args:
            text (str): Input text.
            chunk_size (int): Maximum number of tokens per chunk.
            overlap (int): Number of overlapping tokens.

        Returns:
            list[str]: List of chunks.
        """
        text = self.preprocess_text(text)
        # Split by law sections (e.g., "Điều X")
        law_sections = re.split(r'(Điều\s+\d+[^\n]*\n)', text)
        chunks = []
        current_chunk = ""
        current_size = 0

        for section in law_sections:
            if not section.strip():
                continue
            tokens = section.split()
            section_size = len(tokens)

            if current_size + section_size > chunk_size and current_chunk:
                chunks.append(current_chunk.strip())
                current_chunk = section
                current_size = section_size
            else:
                current_chunk += section
                current_size += section_size

        if current_chunk:
            chunks.append(current_chunk.strip())
        return chunks

    def embed_law_document(
        self,
        articles: list[str],
        metadatas: list[dict] = None,
        chunk_size: int = 512,
        chunk_overlap: int = 50,
    ):
        """
        Chunk and embed law documents into ChromaDB.

        Args:
            articles (list[str]): List of document texts.
            metadatas (list[dict], optional): Metadata for each document.
            chunk_size (int): Maximum chunk size in tokens.
            chunk_overlap (int): Overlap between chunks.
        """
        if metadatas is None:
            metadatas = [{"source": "user"}] * len(articles)
        if len(metadatas) != len(articles):
            raise ValueError("Length of metadatas must match length of articles")

        all_documents = []
        all_embeddings = []
        all_ids = []
        all_metadatas = []

        for article, metadata in zip(articles, metadatas):
            chunks = self.chunk_by_law_structure(article, chunk_size, chunk_overlap)
            embeddings = self.sentence_transformer.encode(chunks, convert_to_numpy=True).tolist()
            ids = [str(uuid.uuid4()) for _ in chunks]

            all_documents.extend(chunks)
            all_embeddings.extend(embeddings)
            all_ids.extend(ids)
            all_metadatas.extend([metadata] * len(chunks))

        try:
            self.collection.add(
                documents=all_documents,
                embeddings=all_embeddings,
                metadatas=all_metadatas,
                ids=all_ids,
            )
            logging.info(f"Added {len(all_documents)} chunks to ChromaDB")
        except Exception as e:
            logging.error(f"Error adding documents to ChromaDB: {e}")
            raise

    def process_kafka_messages(self):
        """
        Consume messages from Kafka and embed them into ChromaDB.
        """
        consumer = KafkaConsumer(
            self.kafka_config["topic"],
            bootstrap_servers=self.kafka_config["bootstrap_servers"],
            group_id=self.kafka_config["group_id"],
            auto_offset_reset="earliest",
            enable_auto_commit=True,
            value_deserializer=lambda x: x.decode("utf-8"),
        )
        try:
            for message in consumer:
                try:
                    data = json.loads(message.value)
                    document = data.get("content", "")
                    metadata = data.get("metadata", {"source": "kafka", "offset": message.offset})
                    if document:
                        document = self.preprocess_text(document)
                        self.embed_law_document(
                            articles=[document],
                            metadatas=[metadata],
                        )
                    else:
                        logging.warning(f"Empty document in Kafka message: {message.offset}")
                except json.JSONDecodeError:
                    logging.error(f"Invalid JSON in Kafka message: {message.offset}")
                    self.producer.send(self.error_topic, value=message.value)
                except Exception as e:
                    logging.error(f"Error processing Kafka message {message.offset}: {e}")
                    self.producer.send(self.error_topic, value=message.value)
        except Exception as e:
            logging.error(f"Error in Kafka consumer loop: {e}")
        finally:
            consumer.close()
            self.producer.close()
            logging.info("Kafka consumer and producer closed")

    def rerank_documents(self, query: str, documents: list[str]) -> list[str]:
        """
        Rerank documents based on relevance to the query.

        Args:
            query (str): Input query.
            documents (list[str]): List of documents to rerank.

        Returns:
            list/str]: Reranked documents.
        """
        pairs = [[query, doc] for doc in documents]
        scores = self.cross_encoder.predict(pairs)
        sorted_docs = [doc for _, doc in sorted(zip(scores, documents), reverse=True)]
        return sorted_docs

    def retrieve_documents(self, query: str) -> dict:
        """
        Retrieve relevant documents for a query.

        Args:
            query (str): Input query.

        Returns:
            dict: Query results from ChromaDB.
        """
        query = self.preprocess_text(query)
        query_embedding = self.sentence_transformer.encode(query, convert_to_numpy=True).tolist()
        try:
            results = self.collection.query(
                query_embeddings=[query_embedding],
                n_results=self.top_k,
                where={"source": {"$in": ["official_law", "kafka"]}},
            )
            if results["documents"]:
                documents = results["documents"][0]
                reranked_docs = self.rerank_documents(query, documents)
                results["documents"][0] = reranked_docs
            return results
        except Exception as e:
            logging.error(f"Error retrieving documents: {e}")
            raise

    def generate_answer(self, query: str) -> str:
        """
        Generate an answer for a query using retrieved documents.

        Args:
            query (str): Input query.

        Returns:
            str: Generated answer.
        """
        try:
            retrieved_docs = self.retrieve_documents(query)
            docs_text = " ".join(retrieved_docs["documents"][0]) if retrieved_docs["documents"] else "Không có tài liệu liên quan."
            
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

    def __del__(self):
        """Close Kafka producer when the object is destroyed."""
        try:
            self.producer.close()
        except Exception:
            pass