import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from dotenv import load_dotenv

# Tải biến môi trường từ file .env ở thư mục gốc project
load_dotenv(os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env'))

# Tạo Base để định nghĩa các model
Base = declarative_base()

# Lấy URL database từ biến môi trường
DATABASE_URL = os.getenv("DATABASE_URL", "mysql+mysqlconnector://root:password@localhost:4000/law_service")
print(DATABASE_URL)

# Tạo engine kết nối database
engine = create_engine(DATABASE_URL,
                       pool_pre_ping=True,  # Kiểm tra kết nối trước khi sử dụng
                       pool_recycle=3600,  # Tái sử dụng kết nối sau 1 giờ
                       echo=False)  # Tắt logging SQL (bật True để debug)

# Tạo session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def create_tables(models=None):
    """
    Tạo các bảng trong database

    :param models: Danh sách các model cần tạo bảng.
                   Nếu None, sẽ tạo tất cả các bảng được định nghĩa
    """
    if models is None:
        # Nếu không truyền models, tạo tất cả các bảng
        Base.metadata.create_all(bind=engine)
    else:
        # Tạo bảng cho các model được chỉ định
        for model in models:
            model.__table__.create(bind=engine, checkfirst=True)


def get_session():
    """Trả về một phiên làm việc mới"""
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()


def init_db():
    """Khởi tạo database và các bảng"""
    from models.models import (
        Pdtopic, Pdsubject, Pdchapter, Pdarticle,
        Pdtable, Pdfile, Pdrelation, Vbqppl, Indexvbqppl
    )

    # Tạo tất cả các bảng
    create_tables([
        Pdtopic, Pdsubject, Pdchapter, Pdarticle,
        Pdtable, Pdfile, Pdrelation, Vbqppl, Indexvbqppl
    ])


# Sử dụng context manager để quản lý session
def db_session():
    """Context manager để sử dụng session"""
    session = SessionLocal()
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()
