from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from .config import config_by_name

db = SQLAlchemy()

def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config_by_name[config_name])
    
    db.init_app(app)
    
    api = Api(app)
    
    # Register routes here
    from .routes import register_routes
    register_routes(api)
    
    return app