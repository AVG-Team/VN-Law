from app.models.conversation_model import Conversation
from app.models.base import db
from datetime import datetime

class ConversationRepository:
    @staticmethod
    def get_by_id(conversation_id):
        conversation = Conversation.query.get(conversation_id)
        if not conversation:
            raise ValueError("Conversation not found")
        return conversation
    
    @staticmethod
    def save(conversation):
        try:
            db.session.add(conversation)
            db.session.commit()
            return conversation
        except Exception as e:
            db.session.rollback()
            raise e

    @staticmethod
    def delete(conversation):
        try:
            db.session.delete(conversation)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise e
        
    @staticmethod
    def get_all():
        return Conversation.query.all()
    
    @staticmethod
    def get_all_by_user_id(user_id):
        return Conversation.query.filter_by(user_id=user_id).all()
    