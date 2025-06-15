from app.models.base import Base, db
from datetime import datetime

class Conversation(Base):
    __tablename__ = "conversations"

    conversation_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Text, nullable=False)
    started_at = db.Column(db.DateTime, default=datetime.utcnow)
    ended_at = db.Column(db.DateTime)
    context = db.Column(db.Text)

    def __init__(self, user_id, context=None, ended_at=None):
        self.user_id = user_id
        self.context = context
        self.ended_at = ended_at

    def __repr__(self):
        return f"<Conversation(id={self.conversation_id}, user_id={self.user_id})>"

    def to_dict(self):
        return {
            "conversation_id": self.conversation_id,
            "user_id": self.user_id,
            "started_at": self.started_at.isoformat() if self.started_at else None,
            "ended_at": self.ended_at.isoformat() if self.ended_at else None,
            "context": self.context,
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
