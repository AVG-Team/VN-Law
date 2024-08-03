from fastapi import FastAPI
from app.api.endpoints import router as api_router
from app.core.database import init_chat_db, close_db, get_chat_db
from app.core.fakerRedis import populate_data_if_empty
from starlette.middleware.cors import CORSMiddleware
from app.websockets.router import router as websocket_router
import asyncio
from app.core.redisClient import redis_client

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def startup_event():
    await init_chat_db()
    await populate_data_if_empty()


@app.get("/")
def root():
    return {"message": "Welcome to the VNLAW AVG API"}


@app.on_event("shutdown")
async def shutdown_event():
    await redis_client.close()
    await asyncio.sleep(1)
    await close_db()


app.include_router(api_router, prefix="/api")
app.include_router(websocket_router)
