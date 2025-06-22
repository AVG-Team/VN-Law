import logging
import os

from fastapi import FastAPI, Depends, HTTPException, Query
from dotenv import load_dotenv
import mysql.connector
from starlette.middleware.cors import CORSMiddleware

from app.models.user import UserInfo
from app.services.auth_service import authenticate_user, get_user_info
from app.services.post_service import PostService
from app.services.notification_service import NotificationService
from app.schemas.response_model import ResponseModel
from app.schemas.post_schema import PostCreateOrUpdate
from app.schemas.comment_schema import CommentCreate, CommentUpdate

# Thiết lập logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
handler = logging.StreamHandler()
handler.setLevel(logging.INFO)
logger.addHandler(handler)

app = FastAPI()
load_dotenv()
db_host = os.getenv("DB_IP", "localhost")
db_username = os.getenv("DB_USERNAME", "root")
db_password = os.getenv("DB_PASSWORD", "password")
db_name = os.getenv("DB_NAME", "forum_service")

# Cấu hình database
db_config = {
    "host": db_host,
    "user": db_username,
    "password": db_password,
    "database": db_name,
}

# Add CORS middleware
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["http://localhost:5173"],  # Frontend URL
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# Dependency để lấy kết nối database
def get_db():
    db = mysql.connector.connect(**db_config)
    try:
        yield db
    finally:
        db.close()

@app.post("/api/posts", response_model=ResponseModel)
async def create_post(post: PostCreateOrUpdate, user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Creating post by user: {user.username}")
    try:
        new_post = PostService.create_post(db, post, user.sub)
        return ResponseModel(status_code=200, message="Post created successfully", data={"post": new_post})
    except Exception as e:
        logger.error(f"Failed to create post: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/posts", response_model=ResponseModel)
async def get_posts(
    filter: str = Query('all'),
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1, le=100),
    user: UserInfo = Depends(authenticate_user),
    db=Depends(get_db)
):
    logger.info(f"Fetching posts with filter: {filter}, page: {page}, page_size: {page_size}")
    try:
        posts = PostService.get_posts(db, filter=filter, page=page, page_size=page_size, keycloak_id=user.sub)
        return ResponseModel(status_code=200, message="Success", data={"posts": posts})
    except Exception as e:
        logger.error(f"Failed to fetch posts: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/posts/search", response_model=ResponseModel)
async def search_posts(query: str, db=Depends(get_db)):
    logger.info(f"Searching posts with query: {query}")
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute(
            """
            SELECT p.*,
                   (SELECT COUNT(*) FROM Likes l WHERE l.post_id = p.id) as likes
            FROM Posts p 
            WHERE p.is_deleted = FALSE AND (p.title LIKE %s OR p.content LIKE %s)
            ORDER BY p.is_pinned DESC, p.created_at DESC
            """, (f"%{query}%", f"%{query}%")
        )
        posts = cursor.fetchall()
        for post in posts:
            user_info = get_user_info(post["keycloak_id"])
            post["name"] = user_info.getName()
            cursor.execute(
                """
                SELECT c.*
                FROM Comments c 
                WHERE c.post_id = %s
                """, (post["id"],)
            )
            comments = cursor.fetchall()
            for comment in comments:
                comment_user_info = get_user_info(comment["keycloak_id"])
                comment["name"] = comment_user_info.getName()
            post["comments"] = comments
        return ResponseModel(status_code=200, message="Success", data={"posts": posts})
    except Exception as e:
        logger.error(f"Failed to search posts: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/posts/{post_id}", response_model=ResponseModel)
async def get_post(post_id: str, db=Depends(get_db)):
    logger.info(f"Fetching post: {post_id}")
    try:
        post = PostService.get_post(db, post_id)
        return ResponseModel(status_code=200, message="Success", data={"post": post})
    except Exception as e:
        logger.error(f"Failed to fetch post: {str(e)}")
        raise HTTPException(status_code=404, detail=str(e))

@app.post("/api/posts/{post_id}/comments", response_model=ResponseModel)
async def create_comment(post_id: str, comment: CommentCreate, user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Creating comment on post: {post_id} by user: {user.username}")
    try:
        new_comment = PostService.create_comment(db, post_id, comment, user.sub)
        # Gửi thông báo
        NotificationService.create_notification(db, post_id, user.sub, user.name)
        return ResponseModel(status_code=200, message="Comment created successfully", data={"comment": new_comment})
    except Exception as e:
        logger.error(f"Failed to create comment: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/api/posts/{post_id}/like", response_model=ResponseModel)
async def like_post(post_id: str, user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Processing like/unlike for post: {post_id} by user: {user.username}")
    try:
        action = PostService.like_post(db, post_id, user.sub)
        message = "Post liked successfully" if action == "like" else "Post unliked successfully"
        return ResponseModel(status_code=200, message=message, data={"action": action})
    except Exception as e:
        logger.error(f"Failed to process like/unlike: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/api/posts/{post_id}/star", response_model=ResponseModel)
async def star_post(post_id: str, user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Processing star/unstar for post: {post_id} by user: {user.username}")
    try:
        action = PostService.star_post(db, post_id, user.sub)
        message = "Post starred successfully" if action == "star" else "Post unstarred successfully"
        return ResponseModel(status_code=200, message=message, data={"action": action})
    except Exception as e:
        logger.error(f"Failed to process star/unstar: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/users/me/likes", response_model=ResponseModel)
async def get_liked_posts(user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Fetching liked posts for user: {user.username}")
    try:
        posts = PostService.get_liked_posts(db, user.sub)
        return ResponseModel(status_code=200, message="Success", data={"posts": posts})
    except Exception as e:
        logger.error(f"Failed to fetch liked posts: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/users/me/stars", response_model=ResponseModel)
async def get_starred_posts(user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Fetching starred posts for user: {user.username}")
    try:
        posts = PostService.get_starred_posts(db, user.sub)
        return ResponseModel(status_code=200, message="Success", data={"posts": posts})
    except Exception as e:
        logger.error(f"Failed to fetch starred posts: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/api/notifications", response_model=ResponseModel)
async def get_notifications(user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Fetching notifications for user: {user.username}")
    try:
        notifications = NotificationService.get_notifications(db, user.sub)
        return ResponseModel(status_code=200, message="Success", data={"notifications": notifications})
    except Exception as e:
        logger.error(f"Failed to fetch notifications: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/api/posts/{post_id}/pin", response_model=ResponseModel)
async def pin_post(post_id: str, user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Pinning post: {post_id} by user: {user.username}")
    realm_roles = user.realm_access.roles if user.realm_access else []
    if "admin-VN-Law" not in realm_roles:
        logger.warning("Unauthorized pin attempt")
        raise HTTPException(status_code=403, detail="Admin only")
    try:
        PostService.pin_post(db, post_id)
        return ResponseModel(status_code=200, message="Post pinned successfully", data={})
    except Exception as e:
        logger.error(f"Failed to pin post: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/api/posts/{post_id}/unpin", response_model=ResponseModel)
async def unpin_post(post_id: str, user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Unpinning post: {post_id} by user: {user.username}")
    realm_roles = user.realm_access.roles if user.realm_access else []
    if "admin-VN-Law" not in realm_roles:
        logger.warning("Unauthorized unpin attempt")
        raise HTTPException(status_code=403, detail="Admin only")
    try:
        PostService.unpin_post(db, post_id)
        return ResponseModel(status_code=200, message="Post unpinned successfully", data={})
    except Exception as e:
        logger.error(f"Failed to unpin post: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.patch("/api/posts/{post_id}", response_model=ResponseModel)
async def update_post(
    post_id: str,
    post: PostCreateOrUpdate,
    user: UserInfo = Depends(authenticate_user),
    db=Depends(get_db)
):
    logger.info(f"Updating post: {post_id} by user: {user.username}")
    try:
        is_admin = "admin-VN-Law" in (user.realm_access.roles if user.realm_access else [])
        updated_post = PostService.update_post(db, post_id, post, user.sub, is_admin)
        return ResponseModel(
            status_code=200,
            message="Post updated successfully",
            data={"post": updated_post}
        )
    except HTTPException as e:
        logger.error(f"Failed to update post: {e.detail}")
        raise
    except Exception as e:
        logger.error(f"Failed to update post: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")

# API Update Comment
@app.patch("/api/comments/{comment_id}", response_model=ResponseModel)
async def update_comment(
    comment_id: str,
    comment: CommentUpdate,
    user: UserInfo = Depends(authenticate_user),
    db=Depends(get_db)
):
    logger.info(f"Updating comment: {comment_id} by user: {user.username}")
    try:
        is_admin = "admin-VN-Law" in (user.realm_access.roles if user.realm_access else [])
        updated_comment = PostService.update_comment(db, comment_id, comment, user.sub, is_admin)
        return ResponseModel(
            status_code=200,
            message="Comment updated successfully",
            data={"comment": updated_comment}
        )
    except HTTPException as e:
        logger.error(f"Failed to update comment: {e.detail}")
        raise
    except Exception as e:
        logger.error(f"Failed to update comment: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.delete("/api/posts/{post_id}", response_model=ResponseModel)
async def delete_post(post_id: str, user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Deleting post: {post_id} by user: {user.username}")
    # required_roles = {"user-VN-Law", "admin-VN-Law"}
    try:
        is_admin = "admin-VN-Law" in (user.realm_access.roles if user.realm_access else [])
        PostService.delete_post(db, post_id, user.sub, is_admin)
        return ResponseModel(status_code=200, message="Post deleted successfully", data={})
    except Exception as e:
        logger.error(f"Failed to delete post: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

@app.delete("/api/comments/{comment_id}", response_model=ResponseModel)
async def delete_comment(comment_id: int, user: UserInfo = Depends(authenticate_user), db=Depends(get_db)):
    logger.info(f"Deleting comment: {comment_id} by user: {user.username}")
    try:
        is_admin = "admin-VN-Law" in (user.realm_access.roles if user.realm_access else [])
        PostService.delete_comment(db, comment_id, user.sub, is_admin)
        return ResponseModel(status_code=200, message="Comment deleted successfully", data={})
    except Exception as e:
        logger.error(f"Failed to delete comment: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))