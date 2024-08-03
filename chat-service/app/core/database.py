from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from app.core.config import DATABASE_URL, AUTH_SERVICE_URL

chat_engine = create_async_engine(DATABASE_URL)
auth_engine = create_async_engine(AUTH_SERVICE_URL)

ChatAsyncSessionLocal = async_sessionmaker(chat_engine, class_=AsyncSession, expire_on_commit=False)
AuthAsyncSessionLocal = async_sessionmaker(auth_engine, class_=AsyncSession, expire_on_commit=False)


async def init_chat_db():
    from app.models.base import Base
    from app.models.message import Message
    from app.models.conversation import Conversation

    async with chat_engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


async def close_db():
    await chat_engine.dispose()
    await auth_engine.dispose()


async def get_chat_db():
    async with ChatAsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()


async def get_auth_db():
    async with AuthAsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()
