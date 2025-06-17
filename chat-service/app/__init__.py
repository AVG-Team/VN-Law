# app/__init__.py
from flask import Flask
from flask_socketio import SocketIO
from flask_migrate import Migrate
from .models.base import db
from .socket_events import register_chat_routes
from config import config_by_name
from .blueprints.chat import chat_bp
from flask import Flask, jsonify
from werkzeug.exceptions import HTTPException

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
    app.register_blueprint(chat_bp, url_prefix='/')

    @app.errorhandler(HTTPException)
    def handle_http_exception(e):
        response = {
            "status_code": e.code,
            "message": e.description,
            "data": None
        }
        return jsonify(response), e.code

    # Xử lý các exception khác (nếu không phải HTTPException)
    @app.errorhandler(Exception)
    def handle_exception(e):
        response = {
            "status_code": 500,
            "message": "Internal server error",
            "data": None
        }
        return jsonify(response), 500

    return app, socketio  # Trả về app và socketio