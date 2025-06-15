import mysql.connector
from mysql.connector import Error
from app.database.fake_data import (
    get_fake_posts,
    get_fake_comments,
    get_fake_likes,
    get_fake_stars,
    get_fake_notifications
)

db_config = {
    "host": "localhost",
    "user": "root",
    "password": "password",
    "database": "forum_service"
}

def insert_fake_data():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        # Chèn Posts
        for post in get_fake_posts():
            cursor.execute(
                """
                INSERT INTO Posts (id, title, content, keycloak_id, created_at, is_pinned, is_deleted)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
                """,
                (
                    post["id"],
                    post["title"],
                    post["content"],
                    post["keycloak_id"],
                    post["created_at"],
                    post["is_pinned"],
                    post["is_deleted"]
                )
            )

        # Chèn Comments
        for comment in get_fake_comments():
            cursor.execute(
                """
                INSERT INTO Comments (id, post_id, keycloak_id, content, parent_id, created_at)
                VALUES (%s, %s, %s, %s, %s, %s)
                """,
                (
                    comment["id"],
                    comment["post_id"],
                    comment["keycloak_id"],
                    comment["content"],
                    comment["parent_id"],
                    comment["created_at"]
                )
            )

        # Chèn Likes
        for like in get_fake_likes():
            cursor.execute(
                """
                INSERT INTO Likes (id, post_id, keycloak_id)
                VALUES (%s, %s, %s)
                """,
                (
                    like["id"],
                    like["post_id"],
                    like["keycloak_id"]
                )
            )

        # Chèn Stars
        for star in get_fake_stars():
            cursor.execute(
                """
                INSERT INTO Stars (id, post_id, keycloak_id)
                VALUES (%s, %s, %s)
                """,
                (
                    star["id"],
                    star["post_id"],
                    star["keycloak_id"]
                )
            )

        # Chèn Notifications
        for notification in get_fake_notifications():
            cursor.execute(
                """
                INSERT INTO Notifications (id, keycloak_id, message, is_read, created_at)
                VALUES (%s, %s, %s, %s, %s)
                """,
                (
                    notification["id"],
                    notification["keycloak_id"],
                    notification["message"],
                    notification["is_read"],
                    notification["created_at"]
                )
            )

        connection.commit()
        print("Fake data inserted successfully")
    except Error as e:
        print(f"Error inserting fake data: {e}")
        connection.rollback()
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()


if __name__ == "__main__":
    insert_fake_data()