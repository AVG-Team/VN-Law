from sqlalchemy import select, and_
from app.models.token import Token
from app.core.database import get_auth_db
from fastapi import Depends, HTTPException, Header
from sqlalchemy.ext.asyncio import AsyncSession
from app.helpers import decode_jwt_token


async def verify_token(token: str, db: AsyncSession = Depends(get_auth_db)):
    stmt = select(Token).where(
        and_(
            Token.token == token,
            Token.revoked.is_(False),
            Token.expired.is_(False)
        )
    )
    result = await db.execute(stmt)
    token_obj = result.scalars().first()
    if not token_obj or decode_jwt_token(token) is None:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    return token_obj.user_id


async def get_current_user_id(authorization: str = Header(None), db: AsyncSession = Depends(get_auth_db)):
    print(authorization)
    if not authorization:
        raise HTTPException(status_code=401, detail="Authorization header missing")

    scheme, token = authorization.split()
    if scheme.lower() != "bearer":
        raise HTTPException(status_code=401, detail="Invalid authentication scheme")

    return await verify_token(token, db)
