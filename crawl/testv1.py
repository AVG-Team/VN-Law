from process.download import download_and_extract_zip
from models.db import get_session
from models.models import *
from process.process_dictionary import process_json_data, insert_topics, insert_subjects, tree_nodes, process_one_file
from process.process_vbqppl import process_vbqppl
from process.split_document import process_split_document
from celery_app import celery_app

def crawl_data():
    print("Crawling started")
    try:
        # Step 1: Download và giải nén file zip
        # download_and_extract_zip()

        # Step 2: Xử lý dữ liệu từ file giải nén
        # process_json_data()

        # Step 3: Kiểm tra và import dữ liệu
        # insert_topics()
        subjects = insert_subjects()

        tree_nodes(subjects)

        # Step 4: Crawl vbqppl
        crawl_vbqppl()

        # Step 5: Split documents
        # split_documents()

    except Exception as e:
        print(f"Error: {e}")

def crawl_vbqppl():
    # Logic từ document-crawler/main.py
    process_vbqppl()
    pass

def split_documents():
    # Logic từ document-crawler/split_document.py
    process_split_document()
    pass

def test_connect():
    # Kiểm tra kết nối đến cơ sở dữ liệu
    with get_session() as session:
        try:
            session.execute("SELECT 1")
            print("Database connection is successful.")
            return True
        except Exception as e:
            print(f"Database connection failed: {e}")
            return False

if __name__ == "__main__":
    # Kiểm tra và tạo bảng trong cơ sở dữ liệu
    if not test_connect():
        print("Database connection failed. Exiting.")
        exit(1)
    # process_one_file("8b06986b-89cf-4a8d-8a2f-e14ff9e3123e.html")
    # Tạo bảng nếu chưa tồn tại
    # Gọi hàm crawl_data
    crawl_data()