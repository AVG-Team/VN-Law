import datetime

from fastapi import APIRouter, Depends, HTTPException
from app.core.auth import get_current_user_id
from app.core.redisClient import redis_client

router = APIRouter()


@router.get("/get-conversations")
async def get_conversations(
        user_id: str = Depends(get_current_user_id)
):
    conversation_ids = await redis_client.smembers(f"user:{user_id}:conversations")
    conversations = []
    for conv_id in conversation_ids:
        conversation = await redis_client.hgetall(f"conversation:{conv_id}")
        if conversation and not conversation.get('deleted_at'):
            conversations.append(conversation)
    conversations.sort(key=lambda x: x['updated_at'], reverse=True)

    return conversations


@router.get("/get-messages/{conversation_id}")
async def get_conversation(
        conversation_id: str,
        user_id: str = Depends(get_current_user_id)
):
    is_user_conversation = await redis_client.sismember(f"user:{user_id}:conversations", conversation_id)
    if not is_user_conversation:
        raise HTTPException(status_code=404, detail="Conversation not found")
    conversation = await redis_client.hgetall(f"conversation:{conversation_id}")
    if not conversation or conversation.get('deleted_at'):
        raise HTTPException(status_code=404, detail="Conversation not found or deleted")
    message_ids = await redis_client.lrange(f"conversation:{conversation_id}:messages", 0, -1)
    messages = []
    for message_id in message_ids:
        message = await redis_client.hgetall(f"message:{message_id}")
        if message:
            messages.append(message)

    return {
        "conversation_id": conversation_id,
        "title": conversation['title'],
        "messages": messages
    }


@router.delete("/delete-conversation/{conversation_id}")
async def delete_conversation(
        conversation_id: str,
        user_id: str = Depends(get_current_user_id)
):
    conversation_key = f"conversation:{conversation_id}"
    conversation = await redis_client.hgetall(conversation_key)
    if not conversation:
        raise HTTPException(status_code=404, detail="Conversation not found")
    await redis_client.hset(conversation_key, 'deleted_at', datetime.datetime.now(datetime.timezone.utc).isoformat())
    await redis_client.srem(f"user:{user_id}:conversations", conversation_id)

    return {"status": "Conversation deleted"}
