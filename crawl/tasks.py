from celery_app import celery
from process.download import download_and_extract_zip
from models.db import get_session
from models.models import *
from process.process_dictionary import process_json_data, insert_topics, insert_subjects, tree_nodes
from process.process_vbqppl import process_vbqppl
from process.split_document import process_split_document

def crawl_data():
    print("Crawling started")
    session = get_session()
    try:
        # Step 1: Download và giải nén file zip
        extract_path = './phap-dien'
        download_and_extract_zip()

        # Step 2: Xử lý dữ liệu từ file giải nén
        process_json_data()

        # Step 3: Kiểm tra và import dữ liệu
        if session.query(Pdtopic).count() == 0:
            insert_topics()
        if session.query(Pdsubject).count() == 0:
            insert_subjects()

        tree_nodes()

        # Step 4: Crawl vbqppl
        if session.query(Vbqppl).count() == 0:
            crawl_vbqppl()

        # Step 5: Split documents
        if session.query(Indexvbqppl).count() == 0:
            split_documents()

        session.commit()
    except Exception as e:
        session.rollback()
        print(f"Error: {e}")
    finally:
        session.close()

def crawl_vbqppl():
    # Logic từ document-crawler/main.py
    process_vbqppl()
    pass

def split_documents():
    # Logic từ document-crawler/split_document.py
    process_split_document()
    pass