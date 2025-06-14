from pydantic import BaseModel

class Like(BaseModel):
    id: int
    post_id: str
    keycloak_id: str