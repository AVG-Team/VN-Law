import logging
import json
import re
import uuid
import numpy as np
import torch
from kafka import KafkaProducer, KafkaConsumer
from sentence_transformers import SentenceTransformer
from sentence_transformers.cross_encoder import CrossEncoder
from transformers import pipeline
import asyncio
import chromadb
from chromadb.utils.embedding_functions import SentenceTransformerEmbeddingFunction
from chromadb.config import Settings
from underthesea import text_normalize
from flask import Flask, jsonify, request
import threading
import time
import os

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

class RAGService:
    def __init__(
        self,
        embedding_model: str = "bkai-foundation-models/vietnamese-bi-encoder",
        generator_model: str = "vinai/PhoGPT-4B-Chat",  # Public Vietnamese model
        kafka_topic: str = "law-document",
        bootstrap_servers: str = "localhost:9092",
        group_id: str = "rag-service-group",
        top_k: int = 5,
        auto_start_kafka: bool = True,
        chroma_host: str = "localhost",
        chroma_port: int = 8010,
        hf_token: str = None,
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
            auto_start_kafka (bool): Whether to start Kafka consumer automatically.
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
                max_length=512,
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
                    max_length=512,
                    token=hf_token,
                )
            except Exception as e:
                logging.error(f"Error loading fallback model: {e}")
                raise

        # Initialize ChromaDB HTTP client
        try:
            TENANT_NAME = "default_tenant"
            DB_NAME = "default"


            # Tạo client chính để sử dụng database và tenant mới
            self.client = chromadb.HttpClient(
                tenant=TENANT_NAME,
                database=DB_NAME,
                host="localhost",
                port=8010,
            )

            embedding_function = SentenceTransformerEmbeddingFunction(model_name="sentence-transformers/all-MiniLM-L6-v2")
            # Lấy hoặc tạo collection
            self.collection = self.client.get_or_create_collection(
                name="law_documents",
                embedding_function=embedding_function,
            )
        except Exception as e:
            logging.error(f"Error initializing ChromaDB client: {e}")
            raise

        self.top_k = top_k

        # Initialize Kafka producer
        try:
            self.producer = KafkaProducer(
                bootstrap_servers=bootstrap_servers,
                value_serializer=lambda v: json.dumps(v).encode('utf-8')
            )
        except Exception as e:
            logging.error(f"Error initializing Kafka producer: {e}")
            raise

        self.error_topic = "error-messages"

        # Store Kafka configuration
        self.kafka_config = {
            "topic": kafka_topic,
            "bootstrap_servers": bootstrap_servers,
            "group_id": group_id,
        }
        self.kafka_thread = None
        self.running = False

        if auto_start_kafka:
            self.start_kafka_consumer()

    async def init_chroma_client(self):
        try:
            # Khởi tạo client ChromaDB bất đồng bộ
            self.client = await chromadb.HttpClient.async_init(
                host="localhost", 
                port=8010
            )
            # Kiểm tra tenant
            await self.client.get_tenant("default_tenant")
            print("ChromaDB client initialized successfully!")
        except Exception as e:
            print(f"Error initializing ChromaDB client: {e}")
            raise

    def preprocess_text(self, text: str) -> str:
        """Normalize Vietnamese text."""
        return text_normalize(text)

    def chunk_by_law_structure(self, text: str, chunk_size: int = 512, overlap: int = 50) -> list[str]:
        """Split text into chunks based on law structure."""
        text = self.preprocess_text(text)
        law_sections = text
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
                current_chunk = " ".join(tokens[-overlap:]) + " " + section if overlap > 0 else section
                current_size = section_size + (overlap if overlap > 0 else 0)
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
        """Chunk and embed law documents into ChromaDB."""
        if metadatas is None:
            metadatas = [{"source": "kafka"}] * len(articles)
        if len(metadatas) != len(articles):
            raise ValueError("Length of metadatas must match length of articles")

        all_documents = []
        all_embeddings = []
        all_ids = []
        all_metadatas = []

        for article, metadata in zip(articles, metadatas):
            article_id = metadata.get("articleId", str(uuid.uuid4()))
            existing = self.collection.get(ids=[article_id])
            if existing['ids']:
                logging.debug(f"Document with articleId {article_id} already exists, skipping")
                continue

            chunks = self.chunk_by_law_structure(article, chunk_size, chunk_overlap)
            embeddings = self.sentence_transformer.encode(chunks, convert_to_numpy=True).tolist()
            ids = [f"{article_id}_{i}" for i in range(len(chunks))]

            all_documents.extend(chunks)
            all_embeddings.extend(embeddings)
            all_ids.extend(ids)
            all_metadatas.extend([metadata] * len(chunks))

        if all_documents:
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
                self.producer.send(self.error_topic, value={"error": str(e)})
                raise
    
    def trigger_embedding(self):
            try:
                request = {"requestType": "ALL"}
                self.producer.send('law-request', request)
                self.producer.flush()
                logging.info("Sent request to law-service: ALL")
            except Exception as e:
                logging.error(f"Error sending request to law-request: {e}")
                raise

    def start_kafka_consumer(self):
        """Start Kafka consumer to process messages."""
        if self.kafka_thread and self.kafka_thread.is_alive():
            logging.info("Kafka consumer is already running.")
            return

        self.running = True
        self.kafka_thread = threading.Thread(target=self.process_kafka_messages, daemon=True)
        self.kafka_thread.start()
        logging.info("Kafka consumer started.")

    def stop_kafka_consumer(self):
        """Stop Kafka consumer."""
        self.running = False
        if self.kafka_thread and self.kafka_thread.is_alive():
            self.kafka_thread.join()
            logging.info("Kafka consumer stopped.")
        self.kafka_thread = None

    def process_kafka_messages(self):
        consumer = None
        batch_size = 100
        while self.running:
            try:
                if consumer is None:
                    consumer = KafkaConsumer(
                        self.kafka_config["topic"],
                        bootstrap_servers=self.kafka_config["bootstrap_servers"],
                        group_id=self.kafka_config["group_id"],
                        auto_offset_reset="earliest",
                        enable_auto_commit=False,
                        value_deserializer=lambda x: json.loads(x.decode("utf-8")) if x and x.strip() else {},
                        max_poll_records=batch_size,
                        max_partition_fetch_bytes=1073741824
                    )
                    logging.info(f"Connected to Kafka topic: {self.kafka_config['topic']}")

                messages = consumer.poll(timeout_ms=1000, max_records=batch_size)
                for topic_partition, partition_messages in messages.items():
                    batch_documents = []
                    batch_metadatas = []
                    for message in partition_messages:
                        if not self.running:
                            break
                        try:
                            data = message.value
                            document = data.get("content", "")
                            metadata = data.get("metadata", {"source": "kafka", "offset": message.offset})
                            is_compressed = data.get("compressed", False)

                            if is_compressed:
                                compressed_bytes = base64.b64decode(document)
                                with gzip.GzipFile(fileobj=io.BytesIO(compressed_bytes), mode='rb') as gz:
                                    document = gz.read().decode('utf-8')

                            if not document:
                                logging.warning(f"Empty document in Kafka message: {message.offset}")
                                continue
                            document = self.preprocess_text(document)
                            batch_documents.append(document)
                            batch_metadatas.append(metadata)
                        except json.JSONDecodeError as e:
                            logging.error(f"Invalid JSON in Kafka message: {message.offset}, error: {e}")
                            self.producer.send(self.error_topic, value={"error": f"Invalid JSON: {message.value}"})
                        except Exception as e:
                            logging.error(f"Error processing Kafka message {message.offset}: {e}")
                            self.producer.send(self.error_topic, value={"error": str(e)})

                    if batch_documents:
                        try:
                            self.embed_law_document(
                                articles=batch_documents,
                                metadatas=batch_metadatas,
                            )
                            consumer.commit()
                            logging.info(f"Processed and committed batch of {len(batch_documents)} documents")
                        except Exception as e:
                            logging.error(f"Error embedding batch: {e}")
                            self.producer.send(self.error_topic, value={"error": str(e)})

            except Exception as e:
                logging.error(f"Error in Kafka consumer loop: {e}")
                if self.running:
                    logging.info("Retrying Kafka consumer in 5 seconds...")
                    time.sleep(5)
                    try:
                        if consumer:
                            consumer.close()
                    except:
                        pass
                    consumer = None
        if consumer:
            try:
                consumer.close()
            except:
                pass
        
    def rerank_documents(self, query: str, documents: list[str]) -> list[str]:
        """Rerank documents based on relevance to the query."""
        pairs = [[query, doc] for doc in documents]
        scores = self.cross_encoder.predict(pairs)
        sorted_docs = [doc for _, doc in sorted(zip(scores, documents), reverse=True)]
        return sorted_docs

    def retrieve_documents(self, query: str) -> dict:
        """Retrieve relevant documents for a query."""
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
        """Generate an answer for a query using retrieved documents."""
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
        except:
            pass


# if __name__ == '__main__':
    rag_service = RAGService(
    bootstrap_servers="localhost:9092",
    chroma_host="localhost",
    chroma_port=8010,
    hf_token=os.getenv("HF_TOKEN")
    )

    # Trigger Law Service
    rag_service.trigger_embedding()
    # Start Kafka consumer
    rag_service.start_kafka_consumer()
    # Keep the script running
    try:
        while True:
            logging.debug("Main loop running...")
            time.sleep(1)
    except KeyboardInterrupt:
        logging.info("Shutting down...")
        rag_service.stop_kafka_consumer()