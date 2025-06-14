from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class CommentCreate(BaseModel):
    content: str
    parent_id: Optional[int] = None

class Comment(BaseModel):
    id: int
    post_id: str
    keycloak_id: str
    name: str
    content: str
    parent_id: Optional[int]
    created_at: datetime

class CommentUpdate(BaseModel):
    content: Optional[str] = None
