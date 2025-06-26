from pydantic import BaseModel
from typing import List, Dict, Any
from datetime import datetime
from pydantic import Field

class Access(BaseModel):
    manageGroupMembership: bool = None
    view: bool = None
    mapRoles: bool = None
    impersonate: bool = None
    manage: bool = None

class UserResponse(BaseModel):
    id: str = None
    createdTimestamp: int = None
    username: str = None
    enabled: bool = None
    totp: bool = None
    emailVerified: bool = None
    firstName: str = None
    lastName: str = None
    email: str = None
    disableableCredentialTypes: List[str] = None
    requiredActions: List[str] = None
    federatedIdentities: List[Any] = None
    notBefore: int = None
    access: Access = None

    class Config:
        # Cho phép ánh xạ các trường JSON với tên giống hệt tên thuộc tính Python
        alias_generator = lambda x: x
        allow_population_by_field_name = True

    def getName(self) -> str:
        return f"{self.firstName} {self.lastName}".strip() if self.firstName or self.lastName else "GUEST"