from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Enum
from datetime import datetime
from app.models.base import Base, db

class Message(Base):
    __tablename__ = "messages"

    message_id = Column(Integer, primary_key=True, autoincrement=True)
    conversation_id = Column(Integer, ForeignKey("conversations.conversation_id"), nullable=False)
    sender = Column(Enum("user", "bot", name="sender_type"), nullable=False)
    content = Column(Text, nullable=False)
    intent = Column(String(50))
    timestamp = Column(DateTime, default=datetime.utcnow)

    def __init__(self, conversation_id, sender, content, intent=None):
        self.conversation_id = conversation_id
        self.sender = sender
        self.content = content
        self.intent = intent
        self.timestamp = datetime.utcnow()

    def __repr__(self):
        return f"<Message(id={self.message_id}, conversation_id={self.conversation_id}, sender={self.sender})>"

    def to_dict(self):
        return {
            "message_id": self.message_id,
            "conversation_id": self.conversation_id,
            "sender": self.sender,
            "content": self.content,
            "intent": self.intent,
            "timestamp": self.timestamp.isoformat() if self.timestamp else None,
        }
    
    def save(self):    
        try:
            db.session.add(self)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise e

    def delete(self):
        try:
            db.session.delete(self)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise e        