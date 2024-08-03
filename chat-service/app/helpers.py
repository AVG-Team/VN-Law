import base64
import base64
import hashlib
import jwt
from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.config import SECRET_KEY
from app.core.database import get_auth_db


def decode_jwt_token(token: str) -> dict:
    secret_key = SECRET_KEY
    md5_hash = hashlib.md5(secret_key.encode('utf-8')).hexdigest()
    hex_key = ''.join(f"{ord(c):x}" for c in md5_hash)
    key_bytes = base64.b64decode(hex_key)
    decoded_jwt = jwt.decode(token, key_bytes, algorithms=["HS256"])
    return decoded_jwt
