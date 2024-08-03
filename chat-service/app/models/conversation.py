from sqlalchemy import Column, String, DateTime
from sqlalchemy.orm import declarative_base, relationship
import uuid
import datetime
from .base import Base


class Conversation(Base):
    __tablename__ = 'conversations'

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(255), nullable=False)
    title = Column(String(250), nullable=False)
    created_at = Column(DateTime, default=datetime.datetime.now(datetime.timezone.utc))
    updated_at = Column(DateTime, default=datetime.datetime.now(datetime.timezone.utc),
                        onupdate=datetime.datetime.now(datetime.timezone.utc))
    deleted_at = Column(DateTime, nullable=True)

    messages = relationship("Message", back_populates="conversation")

    def __repr__(self):
        return (f"<Conversation(id='{self.id}', user_id='{self.user_id}', title='{self.title}',"
                f" created_at='{self.created_at}', updated_at='{self.updated_at}', deleted_at='{self.deleted_at}')>")

    def mark_as_deleted(self):
        self.deleted_at = datetime.datetime.now(datetime.timezone.utc)
