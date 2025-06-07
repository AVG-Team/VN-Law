import os
class Config:
    SECRET_KEY = 'your-secret-key'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    # Use environment variable for database URI, with a default value for development
    SQLALCHEMY_DATABSE_URI= os.getenv('DB_URI', 'mysql+pymysql://root:password@mysql/chat-service')

class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:password@mysql/chat-service-dev'    


class ProductionConfig(Config):
    DEBUG = False
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:password@mysql/chat-service-prod'    



config_by_name = {
    'dev': DevelopmentConfig,
    'prod': ProductionConfig
}