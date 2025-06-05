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
import chromadb
from chromadb.config import Settings
from underthesea import sent_tokenize, text_normalize
from flask import Flask, jsonify
import RAGService


# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

app = Flask(__name__)

# Flask API for embedding
@app.route('/embedding', methods=['POST'])
def trigger_embedding():
    try:
        request = {"requestType": "ALL"}
        rag_service.producer.send('law-request', request)
        rag_service.producer.flush()
        logging.info("Sent request to law-service: ALL")
        return jsonify({"status": "Request sent, embedding in progress"}), 200
    except Exception as e:
        logging.error(f"Error sending request: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/query', methods=['GET'])
def query_collection():
    try:
        results = rag_service.collection.get()
        return jsonify({
            "count": len(results['ids']),
            "documents": results['documents'],
            "metadatas": results['metadatas'],
            "ids": results['ids']
        }), 200
    except Exception as e:
        logging.error(f"Error querying collection: {e}")
        return jsonify({"error": str(e)}), 500

# Initialize RAGService
rag_service = RAGService(
    bootstrap_servers="localhost:9092",  # Update to kafka:9092 for Docker
    chroma_host="localhost",  # Update to chromadb for Docker
    chroma_port=8001  # Use 8001 if 8000 conflicts
)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)