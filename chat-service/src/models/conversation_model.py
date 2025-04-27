from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey
from models.base import Base
from datetime import datetime

class Conversation(Base):
    __tablename__ = "conversations"
    conversation_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    started_at = Column(DateTime, default=datetime.utcnow)
    ended_at = Column(DateTime)
    context = Column(Text)