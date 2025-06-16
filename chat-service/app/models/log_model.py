from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey
from app.models.base import Base
from datetime import datetime

class Log(Base):
    __tablename__ = "logs"
    log_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(String(50), nullable=False)
    action = Column(String(50), nullable=False)
    details = Column(Text)
    timestamp = Column(DateTime, default=datetime.utcnow)