from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Enum
from sqlalchemy.dialects.mysql import LONGTEXT
from datetime import datetime
from app.models.base import Base, db


class Message(Base):
    __tablename__ = "messages"

    message_id = Column(Integer, primary_key=True, autoincrement=True)
    conversation_id = Column(db.String(36), db.ForeignKey('conversations.conversation_id'), nullable=False)
    question = Column(Text)
    content = Column(LONGTEXT, nullable=False)
    context = Column(LONGTEXT)
    intent = Column(String(50))
    user_id = Column(String(50), nullable=True)
    timestamp = Column(DateTime, default=datetime.utcnow)

    def __init__(self, conversation_id, question, content, context, intent=None, user_id=None):
        self.conversation_id = conversation_id
        self.question = question
        self.content = content
        self.context = context
        self.intent = intent
        self.user_id = user_id
        self.timestamp = datetime.utcnow()

    def __repr__(self):
        return f"<Message(id={self.message_id}, conversation_id={self.conversation_id})>"

    def to_dict(self):
        return {
            "message_id": self.message_id,
            "conversation_id": self.conversation_id,
            "question": self.question,
            "content": self.content,
            "context": self.context,
            "intent": self.intent,
            "user_id": self.user_id,
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