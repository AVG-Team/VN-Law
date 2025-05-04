from models.base import Base
from models.base import db
from datetime import datetime

class Conversation(Base):
    __tablename__ = "conversations"

    conversation_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.user_id"), nullable=False)
    started_at = db.Column(db.DateTime, default=datetime.utcnow)
    ended_at = db.Column(db.DateTime)
    context = db.Column(db.Text)

    def __repr__(self):
        return f"<Conversation(id={self.conversation_id}, user_id={self.user_id})>"

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
