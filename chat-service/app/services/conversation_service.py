from app.models.conversation_model import Conversation
from app.models.base import db
from datetime import datetime
from app.repositories.conversation_repository import ConversationRepository

class ConversationService:

    def __init__(self):
        self.conversation_repository = ConversationRepository()

    @staticmethod
    def create_conversation(user_id, context=None):
        conversation = Conversation(user_id=user_id, context=context)
        return ConversationRepository.save(conversation)

    @staticmethod
    def end_conversation(conversation_id):
        conversation = Conversation.query.get(conversation_id)
        if not conversation:
            raise ValueError("Conversation not found")
        conversation.ended_at = datetime.utcnow()
        return ConversationRepository.save(conversation)

    @staticmethod
    def delete_conversation(conversation_id):
        conversation = Conversation.query.get(conversation_id)
        if not conversation:
            raise ValueError("Conversation not found")
        ConversationRepository.delete(conversation)

    @staticmethod
    def get_conversation_by_id(conversation_id):
        conversation = ConversationRepository.get_by_id(conversation_id)
        return conversation.to_dict() if conversation else None
    
    @staticmethod
    def get_all_conversations():
        conversations = ConversationRepository.get_all()
        return [conversation.to_dict() for conversation in conversations]
    
    @staticmethod
    def get_conversations_by_user_id(user_id):
        conversations = ConversationRepository.get_all_by_user_id(user_id)
        return [conversation.to_dict() for conversation in conversations]
