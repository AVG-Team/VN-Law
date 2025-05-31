import logging
import os
import re
import uuid
from datetime import datetime

from bs4 import BeautifulSoup
from tenacity import retry, stop_after_attempt, wait_fixed
from process.helper import read_json_file, convert_roman_to_num, extract_input
from models.db import get_session, db_session
from models.models import *
from process.split_file_js import read_js_file, extract_json_from_js

# Đường dẫn file
TOPIC_FILE = r"./data/phap-dien/jdChuDe.json"
SUBJECT_FILE = r"./data/phap-dien/jdDeMuc.json"
TREE_NODE = r"./data/phap-dien/jdAllTree.json"
SUBJECT_DIRECTORY = r"./data/phap-dien/demuc"

# Thiết lập logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('process.log', encoding='utf-8'),
        logging.StreamHandler()
    ]
)

# Thiết lập logger cho lỗi
error_logger = logging.getLogger('error_logger')
error_handler = logging.FileHandler('error_log.txt', encoding='utf-8')
error_handler.setLevel(logging.ERROR)
error_formatter = logging.Formatter('%(asctime)s - %(levelname)s - File: %(filename)s - %(message)s')
error_handler.setFormatter(error_formatter)
error_logger.addHandler(error_handler)

def process_json_data():
    # Đường dẫn tới file JS (sử dụng đường dẫn đầy đủ)
    js_filepath = r'.\data\phap-dien\jsonData.js'

    # Đọc và xử lý file
    try:
        js_content = read_js_file(js_filepath)
        extract_json_from_js(js_content)
    except Exception as e:
        print(f"Lỗi: {e}")
    pass

def insert_topics():
    print("Load Topics From File ...")
    chudes = read_json_file(TOPIC_FILE)
    # KHÔNG SUBMIT - chỉ log
    for chude in chudes:
        logging.info(f"Would insert topic: {chude['Value']} - {chude['Text']}")
    print("Topics processed (not submitted to DB)!")
    pass

def insert_subjects():
    # Logic thêm dữ liệu từ jdDeMuc.json vào bảng Pdsubject
    print("Load Subjects From File ...")
    demucs = read_json_file(SUBJECT_FILE)
    list_added = []
    with get_session() as session:
        for demuc in demucs:
            if not session.query(Pdsubject).filter_by(id=demuc["Value"]).first():
                session.add(Pdsubject(id=demuc["Value"], name=demuc["Text"], order=demuc["STT"], topic_id=demuc["ChuDe"]))
                list_added.append(demuc["Value"])
            else:
                print(f"Subject {demuc['Value']} already exists, skipping.")
        session.commit()
    print("Inserted all subjects!")
    return list_added

@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def process_file(file_name, json_tree_nodes, dieus_lienquan):
    logging.info(f"Reading HTML content from {file_name}")
    with open(os.path.join(SUBJECT_DIRECTORY, file_name), "r", encoding='utf-8') as demuc_file:
        demuc_html = BeautifulSoup(demuc_file.read(), "html.parser")
        demuc_nodes = [node for node in json_tree_nodes if node["DeMucID"] == file_name.split(".")[0]]

        with get_session() as session:
            logging.info(f"Processing chapters for {file_name}")
            chapter_nodes = [n for n in demuc_nodes if n["TEN"].startswith("Chương ") or n["TEN"].startswith("Phần ")]
            chapters_data = []
            order = 10
            processed_chapter_ids = set()

            for chuong in chapter_nodes:
                if chuong["MAPC"] in processed_chapter_ids or session.query(Pdchapter).filter_by(id=chuong["MAPC"]).first():
                    continue
                order_val = order if chuong["TEN"].startswith("Phần ") else convert_roman_to_num(chuong["ChiMuc"])
                chuong_data = Pdchapter(
                    id=chuong["MAPC"],
                    name=chuong["TEN"],
                    index=chuong["ChiMuc"],
                    order=order_val,
                    subject_id=chuong["DeMucID"]
                )
                chapters_data.append(chuong_data)
                processed_chapter_ids.add(chuong["MAPC"])
                if chuong["TEN"].startswith("Phần "):
                    order += 10
            if not chapters_data:
                chuong_data = Pdchapter(
                    id=str(uuid.uuid4()),
                    name=demuc_html.find("h3").text if demuc_html.find("h3") else "",
                    index="0",
                    order=0,
                    subject_id=file_name.split(".")[0]
                )
                chapters_data.append(chuong_data)

            logging.info(f"Processing articles for {file_name}")
            article_nodes = [n for n in demuc_nodes if n not in chapter_nodes]
            order = 10
            batch = []
            batch_ids = set()

            for i, dieu in enumerate(article_nodes, 1):
                logging.info(f"Processing article {i}/{len(article_nodes)}: {dieu['MAPC']}")
                if len(chapters_data) == 1:
                    dieu["ChuongID"] = chapters_data[0].id
                else:
                    for chuong in chapters_data:
                        if dieu["MAPC"].startswith(chuong.id):
                            dieu["ChuongID"] = chuong.id
                            break

                dieu_html = demuc_html.select_one(f'a[name="{dieu["MAPC"]}"]')
                if not dieu_html:
                    logging.warning(f"No matching HTML element for article {dieu['MAPC']} in {file_name}")
                    continue

                name = str(dieu_html.next_sibling)
                note_html = dieu_html.parent.next_sibling
                vbqppl = note_html.text if note_html else ""
                vbqppl_link = note_html.select_one("a")["href"] if note_html and note_html.select_one("a") else None

                effective_date = None
                if vbqppl:
                    match = re.search(r"có hiệu lực thi hành kể từ ngày (\d{2}/\d{2}/\d{4})", vbqppl)
                    if match:
                        effective_date = datetime.strptime(match.group(1), "%d/%m/%Y").date()

                content_html = dieu_html.parent.find_next_siblings()
                content_str = ""
                tables = []
                for content in content_html:
                    if content.name == "table":
                        tables.append(str(content))
                    elif content.name == "p" and "pChiDan" not in content.get("class", []):
                        content_str += content.text.strip() + "\n"

                pdarticle = Pdarticle(
                    id=dieu["MAPC"],
                    name=name,
                    index=dieu["ChiMuc"],
                    order=order,
                    content=content_str,
                    vbqppl=vbqppl,
                    vbqppl_link=vbqppl_link,
                    chapter_id=dieu.get("ChuongID"),
                    subject_id=dieu["DeMucID"],
                    topic_id=dieu.get("ChuDeID"),
                    effective_date=effective_date
                )
                batch_ids.add(dieu["MAPC"])

                # Kiểm tra Pdarticle tồn tại
                article_exists = session.query(Pdarticle).filter_by(id=dieu["MAPC"]).first()
                if not article_exists:
                    error_msg = f"Article {dieu['MAPC']} not found in Pdarticle for file {file_name}"
                    logging.error(error_msg)
                    error_logger.error(error_msg)
                    continue

                # Xử lý Pdtable
                for table in tables:
                    if not session.query(Pdtable).filter_by(article_id=dieu["MAPC"], html=table).first():
                        logging.info(f"Adding Pdtable for article {dieu['MAPC']}")
                        pdtable = Pdtable(article_id=dieu["MAPC"], html=table)
                        try:
                            batch.append(pdtable)
                        except Exception as e:
                            error_msg = f"Error adding Pdtable for article {dieu['MAPC']} in {file_name}: {e}"
                            logging.error(error_msg)
                            error_logger.error(error_msg)

                # Xử lý Pdfile và Pdrelation
                file_elem = dieu_html.parent.next_sibling
                filesHtml = []
                while file_elem:
                    if file_elem.name == "p" and "pDieu" not in file_elem.get("class", []):
                        anchors = file_elem.select("a[href]")
                        filesHtml.extend(anchors)
                        if "pChiDan" in file_elem.get("class", []):
                            for link in file_elem.select("a"):
                                if "onclick" in link.attrs and link["onclick"]:
                                    id_relation = extract_input(link["onclick"].replace("'", ""))
                                    logging.info(f"Found Pdrelation: {dieu['MAPC']} -> {id_relation}")
                                    if session.query(Pdarticle).filter_by(id=id_relation).first():
                                        dieus_lienquan.append({"idRelation1": dieu["MAPC"], "idRelation2": id_relation})
                                    else:
                                        error_msg = f"Relation ID {id_relation} not found in Pdarticle for article {dieu['MAPC']} in {file_name}"
                                        logging.warning(error_msg)
                                        error_logger.warning(error_msg)
                    if file_elem and "pDieu" in file_elem.get("class", []):
                        break
                    file_elem = file_elem.next_sibling

                for item in filesHtml:
                    if item.name == "a":
                        if item["href"] and item["href"] != "#" and not session.query(Pdfile).filter_by(article_id=dieu["MAPC"], link=item["href"]).first():
                            logging.info(f"Adding Pdfile for article {dieu['MAPC']}: {item["href"]}")
                            pdfile = Pdfile(
                                article_id=dieu["MAPC"],
                                link=item["href"],
                                path=""
                            )
                            try:
                                batch.append(pdfile)
                            except Exception as e:
                                error_msg = f"Error adding Pdfile for article {dieu['MAPC']} in {file_name}: {e}"
                                logging.error(error_msg)
                                error_logger.error(error_msg)

                order += 1

                if len(batch) >= 5:
                    logging.info(f"Committing batch of {len(batch)} items")
                    try:
                        session.bulk_save_objects(batch)
                        session.commit()
                    except Exception as e:
                        session.rollback()
                        error_msg = f"Error committing batch for file {file_name}: {e}"
                        logging.error(error_msg)
                        raise
                    batch.clear()
                    batch_ids.clear()

            if batch:
                logging.info(f"Committing final batch of {len(batch)} items")
                try:
                    session.bulk_save_objects(batch)
                    session.commit()
                except Exception as e:
                    session.rollback()
                    error_msg = f"Error committing final batch for file {file_name}: {e}"
                    logging.error(error_msg)
                    raise

def tree_nodes(subjects=None):
    if subjects is None:
        subjects = []
    logging.info("Load Tree Nodes From File ...")
    print("Load Tree Nodes From File ...")
    json_tree_nodes = read_json_file(TREE_NODE)
    dieus_lienquan = []
    count = 0

    # Tạo tên file trạng thái theo ngày hiện tại (YYYY-MM-DD)
    current_date = datetime.now().strftime("%Y-%m-%d")
    status_file = f"processed_files_{current_date}.txt"
    processed_files = set()
    if os.path.exists(status_file):
        with open(status_file, 'r', encoding='utf-8') as f:
            processed_files = set(line.strip() for line in f)

    for file_name in os.listdir(SUBJECT_DIRECTORY):
        if file_name in processed_files:
            logging.info(f"File {file_name} đã được xử lý, bỏ qua.")
            print(f"File {file_name} đã được xử lý, bỏ qua.")
            continue

        count += 1
        logging.info(f"Starting to process file: {file_name} ({count}/{len(os.listdir(SUBJECT_DIRECTORY))})")
        print(f"Starting to process file: {file_name} ({count}/{len(os.listdir(SUBJECT_DIRECTORY))})")
        try:
            process_file(file_name, json_tree_nodes, dieus_lienquan)
            with open(status_file, 'a', encoding='utf-8') as f:
                f.write(f"{file_name}\n")
            logging.info(f"Finished processing file: {file_name}, total processed: {count}")
            print(f"Finished processing file: {file_name}, total processed: {count}")
        except Exception as e:
            logging.error(f"Error processing file {file_name} after retries: {e}")
            print(f"Error processing file {file_name} after retries: {e}")
            error_logger.error(f"Error processing file {file_name}: {e}")
    # Xử lý relations
    with get_session() as session:
        try:
            logging.info("Processing relations...")
            print("Processing relations...")
            for i, lienquan in enumerate(dieus_lienquan, 1):
                if not session.query(Pdrelation).filter_by(
                        article_id1=lienquan["idRelation1"],
                        article_id2=lienquan["idRelation2"]
                ).first():
                    session.add(Pdrelation(
                        article_id1=lienquan["idRelation1"],
                        article_id2=lienquan["idRelation2"]
                    ))
            session.commit()
        except Exception as e:
            session.rollback()
            logging.error(f"Error inserting relations: {e}")
            print(f"Error inserting relations: {e}")
            error_logger.error(f"Error inserting relations: {e}")

    logging.info("Inserted all relations!")
    print("Inserted all relations!")

def process_one_file(file_name):
    # Chức năng này sẽ xử lý một file duy nhất
    json_tree_nodes = read_json_file(TREE_NODE)
    dieus_lienquan = []
    process_file(file_name, json_tree_nodes, dieus_lienquan)
    return dieus_lienquan