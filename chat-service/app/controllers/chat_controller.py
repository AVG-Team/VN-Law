import os
import logging
from dotenv import load_dotenv
from fastapi import FastAPI, Depends, HTTPException, Request
import requests
from typing import List, Dict, Any, Optional
import hypercorn.asyncio
from hypercorn.config import Config
import asyncio
from pydantic import BaseModel
from services import RAGService, EmbeddingService
import time


from app.models.response_model_chat_api import ResponseModel
from app.models.user_info import UserInfo

# Thiết lập logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Thêm handler để đảm bảo log xuất ra console
handler = logging.StreamHandler()
handler.setLevel(logging.INFO)
logger.addHandler(handler)

# Import các thư viện cần thiết
embedding_service = EmbeddingService()
rag_service = RAGService(embedding_service=embedding_service,use_cpu=False)

app = FastAPI()
load_dotenv()

# Hàm xác thực trả về UserInfo
async def authenticate_user(request: Request) -> UserInfo:
    logger.info("Starting authentication")
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        logger.warning("Missing or invalid Authorization header")
        raise HTTPException(status_code=401, detail="Missing or invalid Authorization header")

    token = auth_header.split(" ")[1]
    logger.info(f"Extracted token: {token}")

    api_auth_url = os.getenv("API_AUTH_URL", "http://localhost:9001")
    validation_url = f"{api_auth_url}/api/auth/validate-token"
    logger.info(f"Validation URL: {validation_url}")

    try:
        logger.info(f"Sending POST request with token: {token}")
        response = requests.post(validation_url, data=token)
        response.raise_for_status()
        data = response.json()
        logger.info(f"Token validation response: {data}")
    except requests.RequestException as e:
        logger.error(f"Authentication service unavailable: {str(e)}")
        raise HTTPException(status_code=503, detail=f"Authentication service unavailable: {str(e)}")
    except ValueError:
        logger.error("Invalid response from authentication service")
        raise HTTPException(status_code=500, detail="Invalid response from authentication service")

    # Chuyển đổi dữ liệu thành UserInfo
    user_info = UserInfo(**data)

    if not user_info.active:
        logger.warning("Token is not active")
        raise HTTPException(status_code=401, detail="Token is not active")

    required_roles = {"user-VN-Law", "admin-VN-Law"}
    realm_roles = user_info.realm_access.roles if user_info.realm_access else []
    if any(role in required_roles for role in realm_roles):
        logger.info(f"Access granted via realm roles: {realm_roles}")
    else:
        resource_access = user_info.resource_access or {}
        for client_roles in resource_access.values():
            roles = client_roles.roles
            if any(role in required_roles for role in roles):
                logger.info(f"Access granted via resource roles: {roles}")
                break
        else:
            logger.warning("Insufficient permissions")
            raise HTTPException(status_code=403, detail="Insufficient permissions")

    return user_info


# Dữ liệu giả lập cho 3 API
messages = [{"id": 1, "text": "Xin chào"}, {"id": 2, "text": "Thế giới"}]
users = [{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}]
settings = {"theme": "dark", "notifications": True}

# Định nghĩa model cho request body
class QuestionRequest(BaseModel):
    question: str

# Các endpoint
@app.post("/api/chat/get-answer")
async def get_messages(request: Request, question: QuestionRequest, user_info: UserInfo = Depends(authenticate_user)):
    start_time = time.time()
    data = request.get_json()
    query = data.get('query', '')
    if not query:
        return ResponseModel(
            status_code=400,
            message="Query is required",
            data=None
        )
    answer = rag_service.generate_answer(query)
    return ResponseModel({
        "status_code": 200,
        "message": "Success",
        "data": {
            "answer": answer,
            "query": query,
            "execution_time": f"{time.time() - start_time:.2f} seconds"
        }
    })

@app.post("/api/chat/get-history")
async def get_settings(request: Request, auth: Optional[None] = Depends(authenticate_user)):
    return ResponseModel(
        status_code=200,
        message="Success",
        data={"history": messages}
    )

@app.route('/retrieve', methods=['POST'])
async def retrieve_endpoint(request: Request, user_info: UserInfo = Depends(authenticate_user)):
    start_time = time.time()
    data = await request.json()
    query = data.get('query', '')
    if not query:
        return ResponseModel(
            status_code=400,
            message="Query is required",
            data=None
        )
    answers = rag_service.retrieve_documents(query)
    return ResponseModel({
        "status_code": 200,
        "message": "Success",
        "data": {
            "answers": answers,
            "query": query,
            "execution_time": f"{time.time() - start_time:.2f} seconds"
        }
    })

# # Cấu hình Hypercorn
# config = Config()
# config.bind = ["0.0.0.0:9068"]  # Chạy trên cổng 9005


# # Hàm chạy ứng dụng
# async def main():
#     await hypercorn.asyncio.serve(app, config)


# if __name__ == "__main__":
#     asyncio.run(main())