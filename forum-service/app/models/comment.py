from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class Comment(BaseModel):
    id: int
    post_id: str
    keycloak_id: str
    name: str
    content: str
    parent_id: Optional[int]
    created_at: datetime