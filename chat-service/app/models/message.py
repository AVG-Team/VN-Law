from sqlalchemy import Column, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
import uuid
import datetime
from .base import Base


class Message(Base):
    __tablename__ = 'messages'

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    conversation_id = Column(String(36), ForeignKey('conversations.id'), nullable=False)
    message = Column(Text, nullable=False)
    reply = Column(Text, nullable=True)
    timestamp = Column(DateTime, default=datetime.datetime.now(datetime.timezone.utc))

    conversation = relationship("Conversation", back_populates="messages")

    def __repr__(self):
        return (f"<Message(id='{self.id}', conversation_id='{self.conversation_id}', message='{self.message}',"
                f" reply='{self.reply}', timestamp='{self.timestamp}')>")

    def to_dict(self):
        return {
            'id': self.id,
            'conversation_id': self.conversation_id,
            'message': self.message,
            'reply': self.reply,
            'timestamp': self.timestamp
        }
