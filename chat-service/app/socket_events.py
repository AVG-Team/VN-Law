from flask import request
from flask_socketio import emit
from app.services.chat_service import ChatbotService
import threading
import time

# Khởi tạo chatbot service
chatbot = ChatbotService()

# Biến để kiểm soát background thread
heartbeat_thread = None
heartbeat_running = False

def register_chat_routes(socketio):
    @socketio.on('connect')
    def handle_connect():
        print(f"Client connected: {request.sid}")
        emit('bot_response', {
            'user': 'Bot', 
            'message': 'Xin chào! Tôi có thể giúp gì cho bạn?',
            'timestamp': time.time()
        })

    @socketio.on('disconnect')
    def handle_disconnect():
        print(f"Client disconnected: {request.sid}")

    @socketio.on('chat_message')
    def handle_chat_message(data):
        try:
            message = data.get('message', '').strip()
            
            if not message:
                emit('error', {'message': 'Tin nhắn không được để trống'})
                return
            
            print(f"User ({request.sid}): {message}")
            
            # Emit typing indicator
            emit('bot_typing', {'typing': True})
            
            # Gọi AI trả lời
            reply = chatbot.get_response(message)
            
            # Stop typing indicator và gửi response
            emit('bot_typing', {'typing': False})
            emit('bot_response', {
                'user': 'Bot', 
                'message': reply,
                'timestamp': time.time()
            })
            
        except Exception as e:
            print(f"Error handling chat message: {e}")
            emit('error', {'message': 'Đã xảy ra lỗi khi xử lý tin nhắn'})

    @socketio.on('user_typing')
    def handle_user_typing(data):
        # Broadcast typing status to other users if needed
        typing = data.get('typing', False)
        emit('user_typing_status', {'typing': typing, 'user_id': request.sid}, broadcast=True, include_self=False)

    # Background heartbeat function
    def background_heartbeat():
        global heartbeat_running
        heartbeat_running = True
        
        while heartbeat_running:
            try:
                socketio.emit('heartbeat', {
                    'msg': '✅ Server đang hoạt động',
                    'timestamp': time.time()
                })
                time.sleep(30)  # Heartbeat mỗi 30 giây
            except Exception as e:
                print(f"Heartbeat error: {e}")
                break

    # Khởi động background thread (chỉ một lần)
    global heartbeat_thread
    if heartbeat_thread is None or not heartbeat_thread.is_alive():
        heartbeat_thread = threading.Thread(target=background_heartbeat)
        heartbeat_thread.daemon = True
        heartbeat_thread.start()
        print("Heartbeat thread started")

    # Event để dừng heartbeat khi cần
    @socketio.on('stop_heartbeat')
    def handle_stop_heartbeat():
        global heartbeat_running
        heartbeat_running = False
        emit('status', {'message': 'Heartbeat stopped'})