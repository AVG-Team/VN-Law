from process.download import download_and_extract_zip
from process.process_dictionary import insert_topics, process_json_data, insert_subjects, tree_nodes
from process.split_file_js import extract_json_from_js
from tasks import crawl_data

try :
    subjects = insert_subjects()
    tree_nodes(subjects)
except Exception as e:
    print(f"Error: {e}")