from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base, User, Conversation, Message, Log
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Database URL from environment variable or default to a local PostgreSQL database
DB_USERNAME = os.getenv("DB_USERNAME")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")

# Create the database URL
DATABASE_URL = "postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# Create Engine
engine = create_engine(DATABASE_URL)

# Create all tables in the database
Base.metadata.create_all(engine)

# Create session
Session = sessionmaker(bind=engine)