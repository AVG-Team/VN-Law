from fastapi import WebSocket
from .manager import manager
from app.models.message import Message
from app.models.conversation import Conversation
from app.core.database import get_chat_db
from sqlalchemy import select, and_
import uuid
import json


async def handle_websocket_message(websocket: WebSocket, data: dict):
    if data['action'] == 'send_message':
        db = await anext(get_chat_db())

        # Kiểm tra và tạo mới conversation nếu không tồn tại
        conversation = await db.execute(select(Conversation).where(
            and_(Conversation.id == data['conversation_id'])
        ))
        conversation = conversation.scalars().first()
        if not conversation:
            conversation = Conversation(
                id=str(uuid.uuid4()),
                user_id=data['user_id'],  # Cần thông tin user_id từ data
                title="New Conversation"
            )
            db.add(conversation)
            await db.commit()
            await db.refresh(conversation)

        # Tạo mới message
        new_message = Message(
            id=str(uuid.uuid4()),
            conversation_id=data['conversation_id'],
            message=data['message']
        )
        db.add(new_message)
        await db.commit()
        await db.refresh(new_message)

        await manager.broadcast(json.dumps({
            'action': 'new_message',
            'message': new_message.to_dict()
        }))
