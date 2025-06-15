from typing import List, Dict, Any

class NotificationService:
    @staticmethod
    def create_notification(db, post_id: str, commenter_id: str, commenter_name: str):
        cursor = db.cursor()
        cursor.execute("SELECT keycloak_id FROM Posts WHERE id = %s", (post_id,))
        post_author_id = cursor.fetchone()[0]
        if post_author_id != commenter_id:
            cursor.execute(
                "INSERT INTO Notifications (keycloak_id, message) VALUES (%s, %s)",
                (post_author_id, f"{commenter_name} đã bình luận bài của bạn")
            )
            db.commit()

    @staticmethod
    def get_notifications(db, keycloak_id: str) -> List[Dict[str, Any]]:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Notifications WHERE keycloak_id = %s ORDER BY created_at DESC", (keycloak_id,))
        return cursor.fetchall()