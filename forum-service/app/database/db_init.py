import os
import mysql.connector
from mysql.connector import Error
from dotenv import load_dotenv

def init_db():
    try:
        load_dotenv()
        db_host = os.getenv("DB_IP", "localhost")
        db_username = os.getenv("DB_USERNAME", "root")
        db_password = os.getenv("DB_PASSWORD", "password")
        db_name = os.getenv("DB_NAME", "forum_service")
        connection = mysql.connector.connect(
            host=db_host,
            user=db_username,
            password=db_password,
            database=db_name
        )
        cursor = connection.cursor()

        # Tạo các bảng

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS Posts (
                id VARCHAR(50) PRIMARY KEY,
                title VARCHAR(255) NOT NULL,
                content TEXT NOT NULL,
                keycloak_id VARCHAR(255) NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                is_pinned BOOLEAN DEFAULT FALSE,
                is_deleted BOOLEAN DEFAULT FALSE
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS Comments (
                id INT PRIMARY KEY AUTO_INCREMENT,
                post_id VARCHAR(255) NOT NULL,
                keycloak_id VARCHAR(255) NOT NULL,
                content TEXT NOT NULL,
                parent_id INT DEFAULT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                FOREIGN KEY (post_id) REFERENCES Posts(id),
                FOREIGN KEY (parent_id) REFERENCES Comments(id)
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS Likes (
                id INT PRIMARY KEY AUTO_INCREMENT,
                post_id VARCHAR(255) NOT NULL,
                keycloak_id VARCHAR(255) NOT NULL,
                FOREIGN KEY (post_id) REFERENCES Posts(id)
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS Stars (
                id INT PRIMARY KEY AUTO_INCREMENT,
                post_id VARCHAR(255) NOT NULL,
                keycloak_id VARCHAR(255) NOT NULL,
                FOREIGN KEY (post_id) REFERENCES Posts(id)
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS Notifications (
                id INT PRIMARY KEY AUTO_INCREMENT,
                keycloak_id VARCHAR(255) NOT NULL,
                message VARCHAR(255) NOT NULL,
                is_read BOOLEAN DEFAULT FALSE,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        """)

        connection.commit()
        print("Database initialized successfully")
    except Error as e:
        print(f"Error initializing database: {e}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

if __name__ == "__main__":
    init_db()