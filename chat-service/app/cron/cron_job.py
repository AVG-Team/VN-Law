import redis
import mysql.connector
import datetime
from app.core.config import redis_client, get_mysql_connection


def transfer_data():
    db_conn = get_mysql_connection()
    db_cursor = db_conn.cursor()
    keys = redis_client.keys('*')
    for key in keys:
        message_data = redis_client.hgetall(key)
        user_id = message_data[b'user_id'].decode('utf-8')
        message = message_data[b'message'].decode('utf-8')
        timestamp = int(message_data[b'timestamp'])

        query = 'INSERT INTO messages (message_id, user_id, message, timestamp) VALUES (%s, %s, %s, %s)'
        db_cursor.execute(query, (key.decode('utf-8'), user_id, message, timestamp))
        db_conn.commit()

        redis_client.delete(key)

    db_cursor.close()
    db_conn.close()
    print(f"Data transferred at {datetime.datetime.now()}")


if __name__ == '__main__':
    transfer_data()
