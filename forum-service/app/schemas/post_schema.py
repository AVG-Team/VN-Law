from pydantic import BaseModel
from datetime import datetime
from typing import List
from app.schemas.comment_schema import Comment


class PostCreateOrUpdate(BaseModel):
    title: str
    content: str

class Post(BaseModel):
    id: str
    title: str
    content: str
    keycloak_id: str
    name: str
    created_at: datetime
    updated_at: datetime
    is_pinned: bool
    is_deleted: bool
    likes: int
    comments: List[Comment]