import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv('DATABASE_URL')
REDIS_URL = os.getenv('REDIS_URL')
AUTH_SERVICE_URL = os.getenv('AUTH_SERVICE_URL')
SECRET_KEY = os.getenv('SECRET_KEY')
