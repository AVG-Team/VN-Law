from app.models.message_model import Message
from app.models.base import db
from datetime import datetime

class MessageRepository:
    @staticmethod
    def get_by_id(conversation_id):
        conversation = Message.query.get(conversation_id)
        if not conversation:
            raise ValueError("Conversation not found")
        return conversation
    
    @staticmethod
    def save(message):
        try:
            db.session.add(message)
            db.session.commit()
            return message
        except Exception as e:
            db.session.rollback()
            raise e

    @staticmethod
    def delete(message):
        try:
            db.session.delete(messages)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise e
        
    @staticmethod
    def get_all():
        return Message.query.all()
    
    @staticmethod
    def get_all_by_user_id(conversation_id):
        return Message.query.filter_by(conversation_id=conversation_id).all()
    