from flask import Flask
from src.api.routes.todo_routes import todo_bp
from src.database.db_config import init_db

def create_app():
    app = Flask(__name__)
    app.config.from_object('config.Config')
    
    # Khởi tạo database
    init_db(app)
    
    # Đăng ký blueprint
    app.register_blueprint(todo_bp, url_prefix='/api/v1')
    
    return app