from flask import Flask
from src.api.routes.routes import send_message
from src.database.database import init_db

def create_app():
    app = Flask(__name__)
    app.config.from_object('config.Config')
    
    # Khởi tạo database
    init_db(app)
    
    # Đăng ký blueprint
    app.register_blueprint(send_message, url_prefix='/api/v1')
    
    return appgunicorn -w 4 -b 0.0.0.0:8000 main:create_app

if __name__ == "__main__":
    app = create_app()
    app.run(debug=True, host="0.0.0.0", port=8000)