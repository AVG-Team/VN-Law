import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from dotenv import load_dotenv
from contextlib import contextmanager  # Thêm import này

# Tải biến môi trường từ file .env ở thư mục gốc project
load_dotenv(os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env'))

# Tạo Base để định nghĩa các model
Base = declarative_base()

# Lấy URL database từ biến môi trường
DATABASE_URL = os.getenv("DATABASE_URL", "mysql+mysqlconnector://root:password@localhost:3306/law_service_check")
print(DATABASE_URL)

# Tạo engine kết nối database
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    pool_recycle=3600,
    pool_timeout=60,
    pool_size=5,
    max_overflow=10,
    echo=False
)

# Tạo session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@contextmanager
def get_session():
    """Trả về một phiên làm việc mới"""
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()

# Các hàm khác giữ nguyên
def create_tables(models=None):
    if models is None:
        Base.metadata.create_all(bind=engine)
    else:
        for model in models:
            model.__table__.create(bind=engine, checkfirst=True)

def init_db():
    from models.models import (
        Pdtopic, Pdsubject, Pdchapter, Pdarticle,
        Pdtable, Pdfile, Pdrelation, Vbqppl, Indexvbqppl
    )
    create_tables([
        Pdtopic, Pdsubject, Pdchapter, Pdarticle,
        Pdtable, Pdfile, Pdrelation, Vbqppl, Indexvbqppl
    ])

def db_session():
    session = SessionLocal()
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()