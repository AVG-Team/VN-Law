import os
from dotenv import load_dotenv

# Load biến môi trường từ file .env
load_dotenv()

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY', 'your-secret-key')
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # Redis
    REDIS_HOST = os.getenv('REDIS_HOST', 'redis')
    REDIS_PORT = int(os.getenv('REDIS_PORT', 6379))

    # Kafka
    KAFKA_BOOTSTRAP_SERVERS = os.getenv('KAFKA_BOOTSTRAP_SERVERS', 'kafka:9092')
    KAFKA_TOPIC = os.getenv('KAFKA_TOPIC', 'conversations')

    # Swagger (nếu dùng flasgger)
    SWAGGER = {
        "title": "Chat Service API",
        "uiversion": 3
    }

class DevelopmentConfig(Config):
    DEBUG = True
    # SQLALCHEMY_DATABASE_URI = os.getenv(
    #     'DEV_DATABASE_URI',
    #     'mysql+pymysql://root:password@mysql-db:3306/chat_service_dev'
    # )
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:password@14.225.218.42:3306/chat_service_dev'

class ProductionConfig(Config):
    DEBUG = False
    SQLALCHEMY_DATABASE_URI = os.getenv(
        'PROD_DATABASE_URI',
        'mysql+pymysql://root:password@14.225.218.42:3306/chat_service_prod'
    )

# Dùng trong create_app()
config_by_name = {
    'dev': DevelopmentConfig,
    'prod': ProductionConfig
}
