from fastapi import FastAPI, HTTPException
from schema import MessageInput, MessageResponse, ConversationResponse
from database import Session, User, Conversation, Message
import json

app = FastAPI()

# Giả lập gọi LLM (thay bằng code thực tế)
def call_llm(user_message: str, context: str = None) -> dict:
    return {
        "response": f"Phản hồi từ LLM: {user_message}",
        "intent": "tu_van_phap_luat"
    }

@app.post("/send_message", response_model=MessageResponse)
async def send_message(message: MessageInput):
    session = Session()
    try:
        # Kiểm tra người dùng
        user = session.query(User).filter_by(user_id=message.user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        # Tìm hoặc tạo cuộc trò chuyện
        conversation = session.query(Conversation).filter_by(user_id=message.user_id, ended_at=None).first()
        if not conversation:
            conversation = Conversation(user_id=message.user_id)
            session.add(conversation)
            session.commit()

        # Lưu tin nhắn người dùng
        user_message = Message(
            conversation_id=conversation.conversation_id,
            sender="user",
            content=message.content
        )
        session.add(user_message)
        session.commit()

        # Gọi LLM
        llm_result = call_llm(message.content, conversation.context)
        bot_response = llm_result["response"]
        intent = llm_result.get("intent")

        # Lưu phản hồi bot
        bot_message = Message(
            conversation_id=conversation.conversation_id,
            sender="bot",
            content=bot_response,
            intent=intent
        )
        session.add(bot_message)

        # Cập nhật ngữ cảnh (nếu cần)
        conversation.context = json.dumps({
            "last_intent": intent,
            "last_message": message.content
        })
        session.commit()

        return bot_message  # Trả về schema MessageResponse
    except Exception as e:
        session.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        session.close()

@app.get("/conversation/{conversation_id}", response_model=ConversationResponse)
async def get_conversation(conversation_id: int):
    session = Session()
    try:
        conversation = session.query(Conversation).filter_by(conversation_id=conversation_id).first()
        if not conversation:
            raise HTTPException(status_code=404, detail="Conversation not found")
        return conversation  # Trả về schema ConversationResponse
    finally:
        session.close()