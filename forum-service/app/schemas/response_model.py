from pydantic import BaseModel
from typing import Any, Optional

class ResponseModel(BaseModel):
    status_code: int
    message: str
    data: Optional[Any]