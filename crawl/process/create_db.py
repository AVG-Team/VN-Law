from models.db import get_session, engine, init_db
from sqlalchemy import text

def alter_pdtable_html_column():
    """Thay đổi cột html trong bảng pdtable thành LONGTEXT"""
    try:
        with engine.connect() as connection:
            # Alter table để thay đổi kiểu dữ liệu cột html
            alter_sql = text("ALTER TABLE pdtable MODIFY COLUMN html LONGTEXT")
            connection.execute(alter_sql)
            connection.commit()
            print("Successfully altered pdtable.html column to LONGTEXT")
    except Exception as e:
        print(f"Error altering table: {e}")

if __name__ == "__main__":
    # init_db()
    alter_pdtable_html_column()