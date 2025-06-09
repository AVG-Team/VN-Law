# from sqlalchemy import Column, Integer, String, DateTime
# from models.base import Base
# from datetime import datetime
#
# class User(Base):
#     __tablename__ = "users"
#     user_id = Column(Integer, primary_key=True, autoincrement=True)
#     username = Column(String(50), nullable=False)
#     email = Column(String(100), unique=True)
#     created_at = Column(DateTime, default=datetime.utcnow)
#     last_active = Column(DateTime)