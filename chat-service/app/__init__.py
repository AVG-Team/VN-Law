from flask import Flask
from flask_socketio import SocketIO
from .routes.chat_routes import register_chat_routes

socketio = SocketIO(cors_allowed_origins="*", async_mode='eventlet')  # or 'threading'

def create_app():
    app = Flask(__name__)
    app.config.from_object('app.config.Config')

    # Register WebSocket
    socketio.init_app(app)

    # Register routes
    register_chat_routes(socketio)

    return app
