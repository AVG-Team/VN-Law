from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Enum
from datetime import datetime
from models.base import Base

class Message(Base):
    __tablename__ = "messages"
    message_id = Column(Integer, primary_key=True, autoincrement=True)
    conversation_id = Column(Integer, ForeignKey("conversations.conversation_id"), nullable=False)
    sender = Column(Enum("user", "bot", name="sender_type"), nullable=False)
    content = Column(Text, nullable=False)
    intent = Column(String(50))
    timestamp = Column(DateTime, default=datetime.utcnow)