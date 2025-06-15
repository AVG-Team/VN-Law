import uuid
from typing import List, Dict, Any
import mysql.connector
from fastapi import HTTPException

from app.schemas.post_schema import PostCreateOrUpdate, Post
from app.schemas.comment_schema import CommentCreate, Comment, CommentUpdate
from app.database.fake_data import get_fake_posts, get_fake_likes, get_fake_stars
from app.services.auth_service import get_user_info


class PostService:
    @staticmethod
    def create_post(db, post: PostCreateOrUpdate, keycloak_id: str) -> str:
        cursor = db.cursor()
        post_id = str(uuid.uuid4())
        cursor.execute(
            "INSERT INTO Posts (id, title, content, keycloak_id) VALUES (%s, %s, %s, %s)",
            (post_id, post.title, post.content, keycloak_id)
        )
        db.commit()
        return post_id


    @staticmethod
    def get_posts(db, filter: str = 'all', page: int = 1, page_size: int = 10, keycloak_id: str = None) -> List[Dict[str, Any]]:
        cursor = db.cursor(dictionary=True)
        offset = (page - 1) * page_size
        query = """
            SELECT p.*,
                   (SELECT COUNT(*) FROM Likes l WHERE l.post_id = p.id) as likes,
                   (SELECT COUNT(*) FROM Comments l WHERE l.post_id = p.id) as commentsCount
            FROM Posts p
            WHERE p.is_deleted = FALSE
        """
        params = []

        if filter == 'pinned':
            query += " AND p.is_pinned = TRUE"
        elif filter == 'liked' and keycloak_id:
            query += " AND p.id IN (SELECT post_id FROM Likes WHERE keycloak_id = %s)"
            params.append(keycloak_id)
        elif filter == 'starred' and keycloak_id:
            query += " AND p.id IN (SELECT post_id FROM Stars WHERE keycloak_id = %s)"
            params.append(keycloak_id)
        elif filter == 'my_posts' and keycloak_id:
            query += " AND p.keycloak_id = %s"
            params.append(keycloak_id)

        query += " ORDER BY p.created_at DESC LIMIT %s OFFSET %s"
        params.extend([page_size, offset])

        cursor.execute(query, tuple(params))
        posts = cursor.fetchall()

        # Lấy 3 bài viết được ghim mới nhất nếu filter là 'all'
        if filter == 'all':
            cursor.execute(
                """
                SELECT p.*,
                       (SELECT COUNT(*) FROM Likes l WHERE l.post_id = p.id) as likes,
                       (SELECT COUNT(*) FROM Comments l WHERE l.post_id = p.id) as commentsCount
                FROM Posts p
                WHERE p.is_deleted = FALSE AND p.is_pinned = TRUE
                ORDER BY p.created_at DESC LIMIT 3
                """
            )
            pinned_posts = cursor.fetchall()
            # Thêm pinned posts vào đầu danh sách, loại bỏ trùng lặp
            posts = pinned_posts + [post for post in posts if post['id'] not in [p['id'] for p in pinned_posts]]

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
        return posts


    @staticmethod
    def get_post(db, post_id: str) -> Dict[str, Any]:
        cursor = db.cursor(dictionary=True)
        cursor.execute(
            """
            SELECT p.*, 
                   (SELECT COUNT(*) FROM Likes l WHERE l.post_id = p.id) as likes,
                   (SELECT COUNT(*) FROM Comments l WHERE l.post_id = p.id) as commentsCount
            FROM Posts p 
            WHERE p.id = %s AND p.is_deleted = FALSE
            """, (post_id,)
        )
        post = cursor.fetchone()
        if not post:
            raise Exception("Post not found")

        # Lấy username từ auth-service
        user_info = get_user_info(post["keycloak_id"])
        post["name"] = user_info.getName()

        # Lấy comments
        cursor.execute(
            """
            SELECT c.* 
            FROM Comments c 
            WHERE c.post_id = %s
            """, (post_id,)
        )
        comments = cursor.fetchall()
        for comment in comments:
            comment_user_info = get_user_info(comment["keycloak_id"])
            comment["name"] = comment_user_info.getName()
        post["comments"] = comments
        return post

    @staticmethod
    def create_comment(db, post_id: str, comment: CommentCreate, keycloak_id: str) -> int:
        cursor = db.cursor()
        cursor.execute(
            "INSERT INTO Comments (post_id, keycloak_id, content, parent_id) VALUES (%s, %s, %s, %s)",
            (post_id, keycloak_id, comment.content, comment.parent_id)
        )
        comment_id = cursor.lastrowid
        db.commit()
        return comment_id

    @staticmethod
    def like_post(db, post_id: str, keycloak_id: str):
        cursor = db.cursor()
        cursor.execute(
            "SELECT * FROM Likes WHERE post_id = %s AND keycloak_id = %s",
            (post_id, keycloak_id)
        )
        if cursor.fetchone():
            # Nếu đã like, xóa like (unlike)
            cursor.execute(
                "DELETE FROM Likes WHERE post_id = %s AND keycloak_id = %s",
                (post_id, keycloak_id)
            )
            db.commit()
            return "unlike"
        else:
            # Nếu chưa like, thêm like
            cursor.execute(
                "INSERT INTO Likes (post_id, keycloak_id) VALUES (%s, %s)",
                (post_id, keycloak_id)
            )
            db.commit()
            return "like"

    @staticmethod
    def star_post(db, post_id: str, keycloak_id: str):
        cursor = db.cursor()
        cursor.execute(
            "SELECT * FROM Stars WHERE post_id = %s AND keycloak_id = %s",
            (post_id, keycloak_id)
        )
        if cursor.fetchone():
            # Nếu đã star, xóa star (unstar)
            cursor.execute(
                "DELETE FROM Stars WHERE post_id = %s AND keycloak_id = %s",
                (post_id, keycloak_id)
            )
            db.commit()
            return "unstar"
        else:
            # Nếu chưa star, thêm star
            cursor.execute(
                "INSERT INTO Stars (post_id, keycloak_id) VALUES (%s, %s)",
                (post_id, keycloak_id)
            )
            db.commit()
            return "star"

    @staticmethod
    def get_liked_posts(db, keycloak_id: str) -> List[Dict[str, Any]]:
        cursor = db.cursor(dictionary=True)
        cursor.execute(
            """
            SELECT p.*, 
                   (SELECT COUNT(*) FROM Likes l WHERE l.post_id = p.id) as likes,
                   (SELECT COUNT(*) FROM Comments l WHERE l.post_id = p.id) as commentsCount
            FROM Posts p 
            JOIN Likes l ON p.id = l.post_id 
            WHERE l.keycloak_id = %s AND p.is_deleted = FALSE
            """, (keycloak_id,)
        )
        posts = cursor.fetchall()
        for post in posts:
            user_info = get_user_info(post["keycloak_id"])
            post["name"] = user_info.getName()
        return posts

    @staticmethod
    def get_starred_posts(db, keycloak_id: str) -> List[Dict[str, Any]]:
        cursor = db.cursor(dictionary=True)
        cursor.execute(
            """
            SELECT p.*, 
                   (SELECT COUNT(*) FROM Likes l WHERE l.post_id = p.id) as likes,
                   (SELECT COUNT(*) FROM Comments l WHERE l.post_id = p.id) as commentsCount
            FROM Posts p 
            JOIN Stars s ON p.id = s.post_id 
            WHERE s.keycloak_id = %s AND p.is_deleted = FALSE
            """, (keycloak_id,)
        )
        posts = cursor.fetchall()
        for post in posts:
            user_info = get_user_info(post["keycloak_id"])
            post["name"] = user_info.getName()
        return posts

    @staticmethod
    def pin_post(db, post_id: str):
        cursor = db.cursor()
        cursor.execute("UPDATE Posts SET is_pinned = TRUE WHERE id = %s", (post_id,))
        db.commit()

    @staticmethod
    def unpin_post(db, post_id: str):
        cursor = db.cursor()
        cursor.execute("UPDATE Posts SET is_pinned = FALSE WHERE id = %s", (post_id,))
        db.commit()

    @staticmethod
    def update_post(db, post_id: str, post: PostCreateOrUpdate, keycloak_id: str, is_admin: bool) -> None:
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(
                "SELECT keycloak_id FROM Posts WHERE id = %s AND is_deleted = FALSE",
                (post_id,)
            )
            post_record = cursor.fetchone()
            if not post_record:
                raise HTTPException(status_code=404, detail="Post not found")

            # Kiểm tra quyền: Người tạo hoặc admin
            if post_record["keycloak_id"] != keycloak_id and not is_admin:
                raise HTTPException(status_code=403, detail="Not authorized to edit this post")

            # Cập nhật bài viết
            cursor.execute(
                """
                UPDATE Posts 
                SET title = %s, content = %s, updated_at = CURRENT_TIMESTAMP 
                WHERE id = %s
                """,
                (post.title, post.content, post_id)
            )
            if cursor.rowcount == 0:
                raise HTTPException(status_code=400, detail="Failed to update post")
            db.commit()
        except HTTPException:
            raise
        except Exception as e:
            db.rollback()
            raise HTTPException(status_code=500, detail="Internal server error")
        finally:
            cursor.close()

    @staticmethod
    def update_comment(db, comment_id: str, comment: CommentUpdate, keycloak_id: str, is_admin: bool) -> None:
        cursor = db.cursor(dictionary=True)
        try:
            # Kiểm tra bình luận tồn tại
            cursor.execute(
                "SELECT keycloak_id FROM Comments WHERE id = %s",
                (comment_id,)
            )
            comment_record = cursor.fetchone()
            if not comment_record:
                raise HTTPException(status_code=404, detail="Comment not found")

            # Kiểm tra quyền: Người tạo hoặc admin
            if comment_record["keycloak_id"] != keycloak_id and not is_admin:
                raise HTTPException(status_code=403, detail="Not authorized to edit this comment")

            # Cập nhật bình luận
            cursor.execute(
                """
                UPDATE Comments 
                SET content = %s, updated_at = CURRENT_TIMESTAMP 
                WHERE id = %s
                """,
                (comment.content, comment_id)
            )
            if cursor.rowcount == 0:
                raise HTTPException(status_code=400, detail="Failed to update comment")
            db.commit()
        except HTTPException:
            raise
        except Exception as e:
            db.rollback()
            raise HTTPException(status_code=500, detail="Internal server error")
        finally:
            cursor.close()

    @staticmethod
    def delete_post(db, post_id: str):
        cursor = db.cursor()
        cursor.execute("UPDATE Posts SET is_deleted = TRUE WHERE id = %s", (post_id,))
        db.commit()

    @staticmethod
    def delete_comment(db, comment_id: int):
        cursor = db.cursor()
        cursor.execute("DELETE FROM Comments WHERE id = %s", (comment_id,))
        db.commit()