# websockets/manager.py
from typing import Dict

from starlette.websockets import WebSocket


class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, WebSocket] = {}

    async def connect(self, websocket: WebSocket, conversation_id: str):
        await websocket.accept()
        self.active_connections[conversation_id] = websocket

    async def disconnect(self, websocket: WebSocket, conversation_id: str):
        if conversation_id in self.active_connections:
            del self.active_connections[conversation_id]

    async def send_personal_message(self, message: dict, conversation_id: str):
        if conversation_id in self.active_connections:
            await self.active_connections[conversation_id].send_json(message)

    async def broadcast(self, message: str):
        for connection in self.active_connections.values():
            await connection.send_text(message)


manager = ConnectionManager()
