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

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

class EmbeddingService:
    def __init__(
            self,
            embedding_model: str = "bkai-foundation-models/vietnamese-bi-encoder",
            top_k: int = 5,
            chroma_host: str = "localhost",
            chroma_port: int = 8000,
            hf_token: str = None,
            # MySQL connection parameters
            mysql_host: str = "localhost",
            mysql_port: int = 3306,
            mysql_user: str = "root",
            mysql_password: str = "password",
            mysql_database: str = "law_service",
    ):
        """
        Initializes the EmbeddingService with the specified parameters.
        This service handles embedding generation, document retrieval, and LLM interactions.
        Args:
            embedding_model (str): Name of the embedding model.
            top_k (int): Number of documents to retrieve.
            chroma_host (str): ChromaDB host.
            chroma_port (int): ChromaDB port.
            hf_token (str): Hugging Face token for private models.
            mysql_host (str): MySQL host.
            mysql_port (int): MySQL port.
            mysql_user (str): MySQL username.
            mysql_password (str): MySQL password.
            mysql_database (str): MySQL database name.
        """
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        logging.info(f"Using device: {self.device}")

        # MySQL connection parameters
        self.mysql_config = {
            'host': mysql_host,
            'port': mysql_port,
            'user': mysql_user,
            'password': mysql_password,
            'database': mysql_database,
            'charset': 'utf8mb4',
            'collation': 'utf8mb4_unicode_ci',
            'autocommit': True
        }

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

    def get_mysql_connection(self):
        """Create MySQL connection."""
        try:
            connection = mysql.connector.connect(**self.mysql_config)
            if connection.is_connected():
                return connection
        except mysql.connector.Error as e:
            logging.error(f"Error connecting to MySQL: {e}")
            raise
        return None

    def preprocess_text(self, text: str) -> str:
        """Normalize Vietnamese text."""
        if not text:
            return ""
        return text_normalize(text)

    def chunk_by_law_structure(self, text: str, chunk_size: int = 512, overlap: int = 50) -> List[str]:
        """Split text into chunks based on law structure."""
        text = self.preprocess_text(text)
        if not text.strip():
            return []

        chunks = []
        current_chunk = ""
        current_size = 0

        # Simple word-based chunking
        words = text.split()

        for word in words:
            if current_size + 1 > chunk_size and current_chunk:
                chunks.append(current_chunk.strip())
                # Add overlap
                overlap_words = current_chunk.split()[-overlap:] if overlap > 0 else []
                current_chunk = " ".join(overlap_words + [word])
                current_size = len(overlap_words) + 1
            else:
                current_chunk += (" " + word if current_chunk else word)
                current_size += 1

        if current_chunk:
            chunks.append(current_chunk.strip())
        return chunks

    def load_law_documents_from_db(self, limit: Optional[int] = None) -> List[Dict]:
        """Load law documents from MySQL database."""
        connection = None
        try:
            connection = self.get_mysql_connection()
            cursor = connection.cursor(dictionary=True)

            # Query to get all law documents with their relationships
            query = """
            SELECT 
                v.vbqppl_id,
                v.content,
                v.html,
                v.type,
                v.number,
                v.effective_date,
                v.status_code,
                v.effective_end_date,
                v.issue_date,
                v.title,
                v.issuer
            FROM vbqppl v
            WHERE v.content IS NOT NULL AND v.content != ''
            """

            if limit:
                query += f" LIMIT {limit}"

            cursor.execute(query)
            documents = cursor.fetchall()

            logging.info(f"Loaded {len(documents)} documents from database")
            return documents
        except mysql.connector.Error as e:
            logging.error(f"Error loading documents from database: {e}")
            raise
        finally:
            if connection and connection.is_connected():
                cursor.close()
                connection.close()

    def load_articles_with_details(self, limit: Optional[int] = None) -> List[Dict]:
        """Load detailed articles from database."""
        connection = None
        try:
            connection = self.get_mysql_connection()
            cursor = connection.cursor(dictionary=True)

            query = """
            SELECT 
                pa.id as article_id,
                pa.name as article_name,
                pa.index as article_index,
                pa.order as article_order,
                pa.content as article_content,
                pa.vbqppl,
                pa.vbqppl_link,
                pc.name as chapter_name,
                ps.name as subject_name,
                pt.name as topic_name,
                pa.effective_date
            FROM pdarticle pa
            LEFT JOIN pdchapter pc ON pa.chapter_id = pc.id
            LEFT JOIN pdsubject ps ON pa.subject_id = ps.id  
            LEFT JOIN pdtopic pt ON pa.topic_id = pt.id
            WHERE pa.content IS NOT NULL AND pa.content != ''
            """

            if limit:
                query += f" LIMIT {limit}"

            cursor.execute(query)
            articles = cursor.fetchall()

            logging.info(f"Loaded {len(articles)} articles from database")
            return articles
        except mysql.connector.Error as e:
            logging.error(f"Error loading articles from database: {e}")
            raise
        finally:
            if connection and connection.is_connected():
                cursor.close()
                connection.close()

    def embed_documents_from_db(self, load_type: str = "articles", limit: Optional[int] = None):
        """Load and embed documents from MySQL database."""
        try:
            if load_type == "articles":
                print("Loading articles with details from database...")
                documents = self.load_articles_with_details(limit)
                self._embed_articles(documents)
            else:
                print("Loading law documents from database...")
                documents = self.load_law_documents_from_db(limit)
                self._embed_law_documents(documents, 100)

        except Exception as e:
            logging.error(f"Error embedding documents from database: {e}")
            raise

    def _embed_articles(self, articles: List[Dict], batch_size: int = 1000):
        """Embed individual articles in batches."""
        total_articles = len(articles)
        for start_idx in range(0, total_articles, batch_size):
            end_idx = min(start_idx + batch_size, total_articles)
            batch_articles = articles[start_idx:end_idx]
            print(f"Processing batch of {len(batch_articles)} articles from {start_idx} to {end_idx}")

            all_documents = []
            all_embeddings = []
            all_ids = []
            all_metadatas = []

            for article in batch_articles:
                article_id = str(article['article_id']) if 'article_id' in article else str(uuid.uuid4())
                print(f"Processing article {article_id}")

                # Check if already exists
                existing = self.collection.get(
                    where={"article_id": article_id},
                    limit=1
                )
                if existing['ids']:
                    print(f"Article {article_id} already exists, skipping")
                    continue

                content = article.get('article_content', '')
                if not content or not content.strip():
                    print(f"Article {article_id} has no content, skipping")
                    continue

                # Create metadata, ensure no None values
                metadata = {
                    'source': 'mysql_db',
                    'type': 'article',
                    'article_id': article_id,
                    'article_name': str(article.get('article_name') or ''),
                    'article_index': str(article.get('article_index') or ''),
                    'chapter_name': str(article.get('chapter_name') or ''),
                    'subject_name': str(article.get('subject_name') or ''),
                    'topic_name': str(article.get('topic_name') or ''),
                    'vbqppl': str(article.get('vbqppl') or ''),
                    'vbqppl_link': str(article.get('vbqppl_link') or ''),
                    'effective_date': str(article.get('effective_date') or '')
                }

                chunks = self.chunk_by_law_structure(content)
                if not chunks:
                    print(f"No chunks for article {article_id}")
                    continue

                try:
                    embeddings = self.sentence_transformer.encode(chunks, convert_to_numpy=True).tolist()
                    ids = [f"article_{article_id}_{i}" for i in range(len(chunks))]
                    print(f"Generated {len(chunks)} chunks for article {article_id}")
                except Exception as e:
                    print(f"Error generating embeddings for article {article_id}: {e}")
                    continue

                all_documents.extend(chunks)
                all_embeddings.extend(embeddings)
                all_ids.extend(ids)
                all_metadatas.extend([metadata] * len(chunks))

            max_batch_size = 41666
            if all_documents:
                print(f"Adding {len(all_documents)} article chunks to ChromaDB")
                for i in range(0, len(all_documents), max_batch_size):
                    batch_documents = all_documents[i:i + max_batch_size]
                    batch_embeddings = all_embeddings[i:i + max_batch_size]
                    batch_ids = all_ids[i:i + max_batch_size]
                    batch_metadatas = all_metadatas[i:i + max_batch_size]
                    try:
                        self.collection.add(
                            documents=batch_documents,
                            embeddings=batch_embeddings,
                            metadatas=batch_metadatas,
                            ids=batch_ids,
                        )
                        print(f"Added {len(batch_documents)} article chunks to ChromaDB")
                    except Exception as e:
                        logging.error(f"Error adding batch to ChromaDB: {e}")
                        raise
            else:
                print("No articles to embed in this batch")

    def _embed_law_documents(self, documents: List[Dict], batch_size: int = 1000):
        """Embed full law documents in batches."""
        total_documents = len(documents)
        for start_idx in range(0, total_documents, batch_size):
            end_idx = min(start_idx + batch_size, total_documents)
            batch_documents = documents[start_idx:end_idx]
            print(f"Processing batch of {len(batch_documents)} documents from {start_idx} to {end_idx}")

            all_documents = []
            all_embeddings = []
            all_ids = []
            all_metadatas = []

            for doc in batch_documents:
                doc_id = str(doc['vbqppl_id']) if 'vbqppl_id' in doc else str(uuid.uuid4())
                print(f"Processing document {doc_id}")

                # Check if already exists
                existing = self.collection.get(
                    where={"vbqppl_id": doc_id},
                    limit=1
                )
                if existing['ids']:
                    print(f"Document {doc_id} already exists, skipping")
                    continue

                content = doc.get('content', '')
                if not content or not content.strip():
                    print(f"Document {doc_id} has no content, skipping")
                    continue

                # Create metadata, ensure no None values
                metadata = {
                    'source': 'mysql_db',
                    'type': 'law_document',
                    'vbqppl_id': doc_id,
                    'title': str(doc.get('title') or ''),
                    'law_type': str(doc.get('type') or ''),
                    'number': str(doc.get('number') or ''),
                    'issuer': str(doc.get('issuer') or ''),
                    'issue_date': str(doc.get('issue_date') or ''),
                    'effective_date': str(doc.get('effective_date') or ''),
                    'effective_end_date': str(doc.get('effective_end_date') or ''),
                    'status_code': str(doc.get('status_code') or '')
                }

                chunks = self.chunk_by_law_structure(content)
                if not chunks:
                    print(f"No chunks for document {doc_id}")
                    continue

                try:
                    embeddings = self.sentence_transformer.encode(chunks, convert_to_numpy=True).tolist()
                    ids = [f"doc_{doc_id}_{i}" for i in range(len(chunks))]
                    print(f"Generated {len(chunks)} chunks for document {doc_id}")
                except Exception as e:
                    print(f"Error generating embeddings for document {doc_id}: {e}")
                    continue

                all_documents.extend(chunks)
                all_embeddings.extend(embeddings)
                all_ids.extend(ids)
                all_metadatas.extend([metadata] * len(chunks))

            max_batch_size = 41666
            if all_documents:
                print(f"Adding {len(all_documents)} document chunks to ChromaDB")
                for i in range(0, len(all_documents), max_batch_size):
                    batch_documents = all_documents[i:i + max_batch_size]
                    batch_embeddings = all_embeddings[i:i + max_batch_size]
                    batch_ids = all_ids[i:i + max_batch_size]
                    batch_metadatas = all_metadatas[i:i + max_batch_size]
                    try:
                        self.collection.add(
                            documents=batch_documents,
                            embeddings=batch_embeddings,
                            metadatas=batch_metadatas,
                            ids=batch_ids,
                        )
                        print(f"Added {len(batch_documents)} document chunks to ChromaDB")
                    except Exception as e:
                        logging.error(f"Error adding batch to ChromaDB: {e}")
                        raise
            else:
                print("No documents to embed in this batch")
