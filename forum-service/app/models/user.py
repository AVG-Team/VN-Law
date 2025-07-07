from typing import List, Dict, Any, Optional
from pydantic import BaseModel

class RealmAccess(BaseModel):
    roles: List[str]

class ResourceAccess(BaseModel):
    roles: List[str]

class UserInfo(BaseModel):
    active: bool
    exp: Optional[int] = None
    iat: Optional[int] = None
    jti: Optional[str] = None
    iss: Optional[str] = None
    aud: Optional[List[str]] = None
    sub: Optional[str] = None
    typ: Optional[str] = None
    azp: Optional[str] = None
    session_state: Optional[str] = None
    name: Optional[str] = None
    given_name: Optional[str] = None
    family_name: Optional[str] = None
    preferred_username: Optional[str] = None
    email: Optional[str] = None
    email_verified: Optional[bool] = None
    acr: Optional[str] = None
    sid: Optional[str] = None
    username: Optional[str] = None
    client_id: Optional[str] = None
    scope: Optional[str] = None
    allowed_origins: Optional[List[str]] = None
    realm_access: Optional[RealmAccess] = None
    resource_access: Optional[Dict[str, ResourceAccess]] = None