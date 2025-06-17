from flask import Blueprint, request, jsonify
from app.models.response_model_chat_api import ResponseModel
from app.models.user_info import UserInfo
from app.services import RAGService, EmbeddingService
import logging
import requests
import os
import time
from dotenv import load_dotenv
from flask import abort  # Import abort từ flask

chat_bp = Blueprint('chat', __name__)
logger = logging.getLogger(__name__)
load_dotenv()

embedding_service = EmbeddingService()
rag_service = RAGService(embedding_service=embedding_service, use_cpu=False)

def authenticate_user(auth_header) -> UserInfo:
    if not auth_header or not auth_header.startswith("Bearer "):
        abort(401, description="Missing or invalid Authorization header")
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
        abort(503, description=f"Authentication service unavailable: {str(e)}")
    except ValueError:
        logger.error("Invalid response from authentication service")
        abort(500, description="Invalid response from authentication service")

    # Chuyển đổi dữ liệu thành UserInfo
    user_info = UserInfo(**data)

    if not user_info.active:
        logger.warning("Token is not active")
        abort(401, description="Token is not active")

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
            abort(403, description="Insufficient permissions")

    return user_info


@chat_bp.route('/api/chat/get-answer', methods=['POST'])
def get_answer():
    start_time = time.time()
    try:
        user_info = authenticate_user(request.headers.get("Authorization"))
        data = request.get_json()
        query = data.get('question', '')
        if not query:
            return jsonify(ResponseModel(status_code=400, message="Query is required", data=None).dict()), 400
        answer = rag_service.generate_answer(query)
        return jsonify(ResponseModel(
            status_code=200,
            message="Success",
            data={"answer": answer, "query": query, "execution_time": f"{time.time() - start_time:.2f} seconds"}
        ).dict()), 200
    except Exception as e:
        logger.error(f"Error in get_answer: {str(e)}")
        return jsonify(ResponseModel(status_code=e.status_code, message=e.detail, data=None).dict()), e.status_code

@chat_bp.route('/api/chat/get-history', methods=['POST'])
def get_history():
    try:
        authenticate_user(request.headers.get("Authorization"))
        return jsonify(ResponseModel(
            status_code=200,
            message="Success",
            data={"history": [{"id": 1, "text": "Xin chào"}, {"id": 2, "text": "Thế giới"}]}
        ).dict()), 200
    except Exception as e:
        logger.error(f"Error in get_history: {str(e)}")
        return jsonify(ResponseModel(status_code=e.status_code, message=e.detail, data=None).dict()), e.status_code
    
@chat_bp.route('/retrieve', methods=['POST'])
def retrieve():
    start_time = time.time()
    try:
        authenticate_user(request.headers.get("Authorization"))
        data = request.get_json()
        query = data.get('query', '')
        if not query:
            return jsonify(ResponseModel(status_code=400, message="Query is required", data=None).dict()), 400
        answers = rag_service.retrieve_documents(query)
        return jsonify(ResponseModel(
            status_code=200,
            message="Success",
            data={"answers": answers, "query": query, "execution_time": f"{time.time() - start_time:.2f} seconds"}
        ).dict()), 200
    except Exception as e:
        return jsonify(ResponseModel(status_code=500, message=str(e), data=None).dict()), 500