from flask import request
from flask_socketio import emit
from app.services.ChatService import ChatbotService
import threading

chatbot = ChatbotService()

def register_chat_routes(socketio):
    @socketio.on('connect')
    def handle_connect():
        print(f"Client connected: {request.sid}")
        emit('bot_response', {'user': 'Bot', 'message': 'Xin chào! Tôi có thể giúp gì cho bạn?'})

    @socketio.on('disconnect')
    def handle_disconnect():
        print(f"Client disconnected: {request.sid}")

    @socketio.on('chat_message')
    def handle_chat_message(data):
        message = data.get('message')
        print(f"User: {message}")

        # Gọi AI trả lời
        reply = chatbot.get_response(message)
        emit('bot_response', {'user': 'Bot', 'message': reply}, to=request.sid)

    # Optional: heartbeat
    def background_heartbeat():
        import time
        while True:
            socketio.emit('heartbeat', {'msg': '✅ Server đang hoạt động'})
            time.sleep(30)

    thread = threading.Thread(target=background_heartbeat)
    thread.daemon = True
    thread.start()
