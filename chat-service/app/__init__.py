# app/__init__.py
from flask import Flask
from flask_socketio import SocketIO
from flask_migrate import Migrate
from .models.base import db
from .socket_events import register_chat_routes
from config import config_by_name

def create_app(config_name='dev'):
    app = Flask(__name__)
    app.config.from_object(config_by_name[config_name])

    db.init_app(app)

    # Khởi tạo Migrate cho app
    migrate = Migrate(app, db)

    # Khởi tạo WebSocket
    socketio = SocketIO(app, cors_allowed_origins="*", async_mode='eventlet')

    # Đăng ký các route (chat_routes)
    register_chat_routes(socketio)

    return app, socketio  # Trả về app và socketio

app, socketio = create_app('dev')