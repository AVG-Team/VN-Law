from app.models.message_model import Message
from app.models.base import db
from app.repositories.messsage_repository import MessageRepository

class MessageService:
    def __init__(self):
        self.message_repository = MessageRepository()

    @staticmethod
    def create_message(conversation_id, user_id, content, sender='user'):
        message = Message(conversation_id=conversation_id, user_id=user_id, content=content, sender=sender)
        return MessageRepository.save(message)

    @staticmethod
    def delete_message(message_id):
        message = MessageRepository.get_by_id(message_id)
        if not message:
            raise ValueError("Message not found")
        MessageRepository.delete(message)

    @staticmethod
    def get_message_by_id(message_id):
        message = MessageRepository.get_by_id(message_id)
        return message.to_dict() if message else None

    @staticmethod
    def get_all_messages():
        messages = MessageRepository.get_all()
        return [message.to_dict() for message in messages]

    @staticmethod
    def get_messages_by_conversation_id(conversation_id):
        messages = MessageRepository.get_all_by_user_id(conversation_id)
        return [message.to_dict() for message in messages]