from typing import List, Dict, Any, Optional
from pydantic import BaseModel

class ResponseModel(BaseModel):
    status_code: int
    message: str
    data: Any