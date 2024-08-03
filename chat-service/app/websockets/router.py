import asyncio
import json
import logging
import uuid
from typing import Optional
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from starlette.websockets import WebSocketState

from app.core.auth import get_current_user_id
from .manager import manager

logger = logging.getLogger(__name__)

router = APIRouter()


@router.websocket("/ws/")
@router.websocket("/ws/{conversation_id}")
async def websocket_endpoint(
        websocket: WebSocket,
        conversation_id: Optional[str] = None
):
    if conversation_id is None:
        conversation_id = str(uuid.uuid4())

    await manager.connect(websocket, conversation_id)

    try:
        print(f"New connection established: {conversation_id}")

        # Receive initial data with timeout
        try:
            jsonData = await asyncio.wait_for(websocket.receive_text(), timeout=10.0)
            data = json.loads(jsonData)
            token = data.get('token')
            print(f"Token received: {token}")
            if not token:
                await websocket.close(code=4000)
                return

        except asyncio.TimeoutError:
            logger.warning(f"Timeout waiting for initial data from {conversation_id}")
            await websocket.close(code=4000)
            return
        except json.JSONDecodeError:
            logger.error(f"Invalid JSON received from {conversation_id}")
            await websocket.close(code=4000)
            return

        while True:
            try:
                # Receive data with timeout
                data = await asyncio.wait_for(websocket.receive_text(), timeout=30.0)
                # Process data here
                print("Data send : ", data)
                await manager.send_personal_message(f"You wrote: {data}", conversation_id)
            except asyncio.TimeoutError:
                logger.info(f"No data received from {conversation_id} for 30 seconds")
                # You might want to send a ping here to check if the connection is still alive
                continue
            except WebSocketDisconnect:
                logger.info(f"WebSocket disconnected for {conversation_id}")
                break
            except Exception as e:
                logger.error(f"An error occurred for {conversation_id}: {str(e)}")
                if websocket.client_state == WebSocketState.DISCONNECTED:
                    break
                continue
    finally:
        await manager.disconnect(websocket, conversation_id)
        logger.info(f"Connection closed for client {conversation_id}")
