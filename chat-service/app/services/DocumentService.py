import json
import logging
from kafka import KafkaConsumer
from typing import Optional

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

class DocumentService:
    def __init__(
        self,
        topic: str = "law-document",
        bootstrap_servers: str = "localhost:9092",
        group_id: str = "law-document-group",
        auto_offset_reset: str = "earliest",
        enable_auto_commit: bool = True,
        value_deserializer: callable = lambda x: x.decode("utf-8"),
    ):
        """
        Initialize DocumentService with a Kafka consumer.

        Args:
            topic (str): Kafka topic to subscribe to.
            bootstrap_servers (str): Kafka bootstrap servers.
            group_id (str): Consumer group ID.
            auto_offset_reset (str): Offset reset policy ('earliest', 'latest', etc.).
            enable_auto_commit (bool): Enable auto commit of offsets.
            value_deserializer (callable): Function to deserialize message values.
        """
        self.topic = topic
        self.consumer = KafkaConsumer(
            topic,
            bootstrap_servers=bootstrap_servers,
            auto_offset_reset=auto_offset_reset,
            enable_auto_commit=enable_auto_commit,
            group_id=group_id,
            value_deserializer=value_deserializer,
        )
        logging.info(f"Initialized Kafka consumer for topic: {topic}")

    def load_all_documents(self) -> list[dict]:
        """
        Load all documents from the Kafka topic.

        Returns:
            list[dict]: List of documents with content and metadata.
        """
        documents = []
        try:
            logging.info(f"Listening to topic: {self.topic}")
            for message in self.consumer:
                try:
                    data = json.loads(message.value)
                    document = {
                        "content": data.get("content", ""),
                        "metadata": data.get("metadata", {"source": "kafka", "offset": message.offset}),
                    }
                    if document["content"]:
                        documents.append(document)
                        logging.info(f"Consumed document: {document['content'][:50]}...")
                    else:
                        logging.warning(f"Empty document at offset: {message.offset}")
                except json.JSONDecodeError:
                    logging.error(f"Invalid JSON at offset: {message.offset}")
                    continue
        except Exception as e:
            logging.error(f"Error consuming messages: {e}")
            raise
        finally:
            self.consumer.close()
            logging.info("Kafka consumer closed")
        return documents

    def __del__(self):
        """Ensure the consumer is closed when the object is destroyed."""
        try:
            self.consumer.close()
        except Exception:
            pass
