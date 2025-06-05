from flask import Flask
from flask_socketio import SocketIO
from app.routes.chat_routes import register_chat_routes

app = Flask(__name__)
app.config['SECRET_KEY'] = 'supersecret'
socketio = SocketIO(app, cors_allowed_origins='*')

# Đăng ký các routes
register_chat_routes(socketio)

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)
