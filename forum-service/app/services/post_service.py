import uuid
from typing import List, Dict, Any
import mysql.connector
from fastapi import HTTPException

from app.schemas.post_schema import PostCreateOrUpdate, Post
from app.schemas.comment_schema import CommentCreate, Comment, CommentUpdate
from app.database.fake_data import get_fake_posts, get_fake_likes, get_fake_stars
from app.services.auth_service import get_user_info, get_admin_user_ids


class PostService:
    @staticmethod
    def create_post(db, post: PostCreateOrUpdate, keycloak_id: str) -> dict:
        cursor = db.cursor()
        post_id = str(uuid.uuid4())
        cursor.execute(
            "INSERT INTO Posts (id, title, content, keycloak_id) VALUES (%s, %s, %s, %s)",
            (post_id, post.title, post.content, keycloak_id)
        )
        db.commit()
        # Lấy lại bài viết vừa tạo
        cursor.execute("""
               SELECT p.id, p.title, p.content, p.keycloak_id, p.created_at, p.updated_at
               FROM Posts p
               WHERE p.id = %s
           """, (post_id,))
        result = cursor.fetchone()

        if not result:
            raise Exception("Failed to retrieve created post.")

        return result


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

            # lấy danh sách id admin
        admin_user_ids = get_admin_user_ids()

        for post in posts:
            user_info = get_user_info(post["keycloak_id"])
            post["name"] = user_info.getName()
            post["is_admin"] = post["keycloak_id"] in admin_user_ids
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
                comment["is_admin"] = comment["keycloak_id"] in admin_user_ids
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

        # Get Admin List Id
        admin_user_ids = get_admin_user_ids()
        user_info = get_user_info(post["keycloak_id"])
        post["name"] = user_info.getName()
        post["is_admin"] = post["keycloak_id"] in admin_user_ids

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
            comment["is_admin"] = comment["keycloak_id"] in admin_user_ids
        post["comments"] = comments
        return post

    @staticmethod
    def create_comment(db, post_id: str, comment: CommentCreate, keycloak_id: str) -> dict:
        cursor = db.cursor(dictionary=True)

        # Insert comment
        cursor.execute(
            "INSERT INTO Comments (post_id, keycloak_id, content, parent_id) VALUES (%s, %s, %s, %s)",
            (post_id, keycloak_id, comment.content, comment.parent_id)
        )
        comment_id = cursor.lastrowid
        db.commit()

        # Lấy thông tin comment vừa tạo
        cursor.execute("""
            SELECT *
            FROM Comments c
            WHERE c.id = %s
        """, (comment_id,))
        new_comment = cursor.fetchone()

        if not new_comment:
            raise Exception("Failed to retrieve created comment.")

        return new_comment

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
    def update_post(db, post_id: str, post: PostCreateOrUpdate, keycloak_id: str, is_admin: bool) -> dict:
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

            # Trả về bài viết sau khi cập nhật
            cursor.execute("""
                        SELECT p.id, p.title, p.content, p.keycloak_id, p.created_at, p.updated_at
                        FROM Posts p
                        WHERE p.id = %s
                    """, (post_id,))
            updated_post = cursor.fetchone()

            return updated_post
        except HTTPException:
            raise
        except Exception as e:
            db.rollback()
            raise HTTPException(status_code=500, detail="Internal server error")
        finally:
            cursor.close()

    @staticmethod
    def update_comment(db, comment_id: str, comment: CommentUpdate, keycloak_id: str, is_admin: bool) -> dict:
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

            cursor.execute("""
                        SELECT c.id, c.content, c.post_id, c.keycloak_id, c.parent_id, c.created_at, c.updated_at
                        FROM Comments c
                        WHERE c.id = %s
                    """, (comment_id,))
            updated_comment = cursor.fetchone()

            return updated_comment
        except HTTPException:
            raise
        except Exception as e:
            db.rollback()
            raise HTTPException(status_code=500, detail="Internal server error " + str(e))
        finally:
            cursor.close()

    @staticmethod
    def delete_post(db, post_id: str, keycloak_id: str, is_admin: bool):
        cursor = db.cursor(dictionary=True)
        try:
            # Kiểm tra bài viết tồn tại
            cursor.execute(
                "SELECT keycloak_id FROM Posts WHERE id = %s",
                (post_id,)
            )
            post_record = cursor.fetchone()
            if not post_record:
                raise HTTPException(status_code=404, detail="Post not found")

            # Kiểm tra quyền xoá: chỉ admin hoặc chính chủ
            if post_record["keycloak_id"] != keycloak_id and not is_admin:
                raise HTTPException(status_code=403, detail="Not authorized to delete this post")

            # Đánh dấu đã xoá
            cursor.execute("UPDATE Posts SET is_deleted = TRUE WHERE id = %s", (post_id,))
            if cursor.rowcount == 0:
                raise HTTPException(status_code=400, detail="Failed to delete post")

            db.commit()
            return {"message": "Post deleted successfully"}

        except HTTPException:
            raise
        except Exception as e:
            db.rollback()
            raise HTTPException(status_code=500, detail="Internal server error " + str(e))
        finally:
            cursor.close()

    @staticmethod
    def delete_comment(db, comment_id: int, keycloak_id: str, is_admin: bool):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(
                "SELECT keycloak_id FROM Comments WHERE id = %s",
                (comment_id,)
            )
            comment_record = cursor.fetchone()
            if not comment_record:
                raise HTTPException(status_code=404, detail="Comment not found")

            # Kiểm tra quyền xoá: chỉ admin hoặc chính chủ
            if comment_record["keycloak_id"] != keycloak_id and not is_admin:
                raise HTTPException(status_code=403, detail="Not authorized to delete this comment")

            cursor.execute("DELETE FROM Comments WHERE id = %s", (comment_id,))
            if cursor.rowcount == 0:
                raise HTTPException(status_code=400, detail="Failed to delete comment")
            db.commit()
            return {"message": "Comment deleted successfully"}
        except HTTPException:
            raise
        except Exception as e:
            db.rollback()
            raise HTTPException(status_code=500, detail="Internal server error " + str(e))
        finally:
            cursor.close()