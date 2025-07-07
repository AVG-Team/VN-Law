# app.py chính
from app import create_app
from flask_cors import CORS
from flask_socketio import SocketIO
from flask_migrate import Migrate
from app.models import db

# Khởi tạo Flask app và socketio từ create_app
app, socketio = create_app("dev")

CORS(app, resources={r"/api/*": {"origins": "http://localhost:5173"}})

# Khởi tạo Migrate và kết nối db
migrate = Migrate(app, db)

# Chạy app
if __name__ == "__main__":
    socketio.run(app, host="0.0.0.0", port=9006, debug=True, allow_unsafe_werkzeug=True)
