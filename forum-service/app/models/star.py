from pydantic import BaseModel

class Star(BaseModel):
    id: int
    post_id: str
    keycloak_id: str