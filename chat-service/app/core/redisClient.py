from redis import asyncio as aioredis
from app.core.config import REDIS_URL

redis_client = aioredis.from_url(REDIS_URL, decode_responses=True)