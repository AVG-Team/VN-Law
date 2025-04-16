from process.download import download_and_extract_zip
from models.db import get_session
from models.models import *
from process.process_dictionary import process_json_data, insert_topics, insert_subjects, tree_nodes
from process.process_vbqppl import process_vbqppl
from process.split_document import process_split_document
from celery_app import celery_app

@celery_app.task(name='tasks.test_crawl_dat_tasks')
def test_crawl_dat_tasks():
    print("Test crawl data tasks")

@celery_app.task(name='tasks.crawl_data')
def crawl_data():
    print("Crawling started")
    try:
        # Step 1: Download và giải nén file zip
        download_and_extract_zip()

        # Step 2: Xử lý dữ liệu từ file giải nén
        process_json_data()

        # Step 3: Kiểm tra và import dữ liệu
        insert_topics()
        subjects = insert_subjects()

        tree_nodes(subjects)

        # Step 4: Crawl vbqppl
        crawl_vbqppl()

        # Step 5: Split documents
        split_documents()

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