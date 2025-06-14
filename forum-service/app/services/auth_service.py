import requests
from fastapi import HTTPException, Request

from app.models.user import UserInfo
import os
from dotenv import load_dotenv
import logging

from app.schemas.user_response import UserResponse

load_dotenv()
logger = logging.getLogger(__name__)


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
        raise HTTPException(status_code=503, detail=f"Authentication service unavailable")
    except ValueError:
        logger.error("Invalid response from authentication service")
        raise HTTPException(status_code=500, detail="Invalid response from authentication service")

    aud = data.get("aud")
    if isinstance(aud, str):
        data["aud"] = [aud]
    elif not isinstance(aud, (list, type(None))):
        logger.warning(f"Trường aud không hợp lệ: {aud}")
        raise HTTPException(status_code=400, detail="Trường aud không hợp lệ")

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


def get_user_info(keycloak_id: str) -> UserResponse | dict[str, str]:
    api_url = f"{os.getenv('API_AUTH_URL', 'http://localhost:9001')}/api/auth/get-user-by-id/{keycloak_id}"
    try:
        response = requests.get(api_url)
        response.raise_for_status()
        data = response.json()
        logger.info(f"Phản hồi từ API lấy thông tin người dùng: {data}")

        # Kiểm tra xem phản hồi có chứa trường 'data' không
        if "data" not in data:
            logger.error(f"Phản hồi API không chứa trường 'data': {data}")
            return {"name": "Unknown"}

        # Trích xuất phần 'data'
        user_data = data["data"]
        print("User info retrieved successfully", user_data)

        # Chuyển đổi thành UserResponse
        user = UserResponse(**user_data)
        logger.info(f"Thông tin người dùng đã lấy: {user.username}")

        if user.id is None:
            logger.warning(f"ID người dùng không tồn tại: {user.id}")
            return {"name": "Unknown"}

        return user
    except requests.RequestException as e:
        logger.error(f"Lỗi khi gọi API lấy thông tin người dùng: {str(e)}")
        return {"name": "Unknown"}
    except ValueError as e:
        logger.error(f"Lỗi khi phân tích phản hồi API: {str(e)}")
        return {"name": "Unknown"}