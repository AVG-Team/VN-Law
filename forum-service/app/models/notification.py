from pydantic import BaseModel
from datetime import datetime

class Notification(BaseModel):
    id: int
    keycloak_id: str
    message: str
    is_read: bool
    created_at: datetime