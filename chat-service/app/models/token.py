from datetime import datetime, timedelta
from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import declarative_base
from app.helpers import decode_jwt_token

Base = declarative_base()


class Token(Base):
    __tablename__ = 'token'

    id = Column(Integer, primary_key=True, index=True)
    token = Column(String(255), unique=True, index=True, nullable=False)
    expired = Column(Boolean, default=False)
    revoked = Column(Boolean, default=False)
    user_id = Column(String(255), ForeignKey('users.id'), nullable=False)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if not self.expired:
            self.expired = datetime.utcnow() + timedelta(days=1)

    def is_valid(self):
        return (
                not self.revoked and
                not self.expired and
                decode_jwt_token(self.token).get('sub') is not None
        )
