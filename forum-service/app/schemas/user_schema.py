from pydantic import BaseModel

class User(BaseModel):
    username: str
    email: str
    password: str

class UserInDB(User):
    id: int
    role: str