import os
import re
import uuid
from datetime import datetime

from bs4 import BeautifulSoup

from process.helper import read_json_file, convert_roman_to_num, extract_input
from models.db import get_session, db_session
from models.models import *
from process.split_file_js import read_js_file, extract_json_from_js

# Đường dẫn file
TOPIC_FILE = r"./data/phap-dien/jdChuDe.json"
SUBJECT_FILE = r"./data/phap-dien/jdDeMuc.json"
TREE_NODE = r"./data/phap-dien/jdAllTree.json"
SUBJECT_DIRECTORY = r"./data/phap-dien/demuc"

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
    with get_session() as session:
        for chude in chudes:
            if not session.query(Pdtopic).filter_by(id=chude["Value"]).first():
                session.add(Pdtopic(id=chude["Value"], name=chude["Text"], order=chude["STT"]))
        session.commit()
    print("Inserted all topics!")
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
        session.commit()
    print("Inserted all subjects!")
    return list_added

def tree_nodes(subjects=None):
    if subjects is None:
        subjects = []
    print("Load Tree Nodes From File ...")
    json_tree_nodes = read_json_file(TREE_NODE)
    dieus_lienquan = []
    count = 0
    BATCH_SIZE = 50

    for file_name in os.listdir(SUBJECT_DIRECTORY):
        count += 1
        if file_name.split(".")[0] not in subjects:
            print(f"No nodes found for list subject added: {file_name}")
            continue
        with get_session() as session:
            with open(os.path.join(SUBJECT_DIRECTORY, file_name), "r", encoding='utf-8') as demuc_file:
                demuc_html = BeautifulSoup(demuc_file.read(), "html.parser")
                demuc_nodes = [node for node in json_tree_nodes if node["DeMucID"] == file_name.split(".")[0]]
                if not demuc_nodes:
                    print(f"No nodes found for subject: {file_name}, node: {demuc_nodes}")
                    continue

                try:
                    # Xử lý chương
                    chapter_nodes = [n for n in demuc_nodes if
                                     n["TEN"].startswith("Chương ") or n["TEN"].startswith("Phần ")]
                    chapters_data = []
                    order = 10
                    for chuong in chapter_nodes:
                        order_val = order if chuong["TEN"].startswith("Phần ") else convert_roman_to_num(chuong["ChiMuc"])
                        chuong_data = Pdchapter(
                            id=chuong["MAPC"],
                            name=chuong["TEN"],
                            index=chuong["ChiMuc"],
                            order=order_val,
                            subject_id=chuong["DeMucID"]
                        )
                        if not session.query(Pdchapter).filter_by(id=chuong["MAPC"]).first():
                            session.add(chuong_data)
                        chapters_data.append(chuong_data)
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
                        if not session.query(Pdchapter).filter_by(id=chuong_data.id).first():
                            session.add(chuong_data)
                        chapters_data.append(chuong_data)
                    session.commit()

                    # Xử lý điều
                    article_nodes = [n for n in demuc_nodes if n not in chapter_nodes]
                    order = 10
                    batch = []
                    for dieu in article_nodes:
                        if len(chapters_data) == 1:
                            dieu["ChuongID"] = chapters_data[0].id
                        else:
                            for chuong in chapters_data:
                                if dieu["MAPC"].startswith(chuong.id):
                                    dieu["ChuongID"] = chuong.id
                                    break

                        dieu_html = demuc_html.select_one(f'a[name="{dieu["MAPC"]}"]')
                        if not dieu_html:
                            continue
                        name = str(dieu_html.next_sibling)
                        note_html = dieu_html.parent.next_sibling
                        vbqppl = note_html.text if note_html else ""
                        vbqppl_link = note_html.select_one("a")["href"] if note_html and note_html.select_one("a") else None

                        # Trích xuất ngày hiệu lực từ vbqppl và chuyển thành date
                        effective_date = None
                        if vbqppl:
                            match = re.search(r"có hiệu lực thi hành kể từ ngày (\d{2}/\d{2}/\d{4})", vbqppl)
                            if match:
                                date_str = match.group(1)  # Lấy ngày dạng DD/MM/YYYY
                                effective_date = datetime.strptime(date_str, "%d/%m/%Y").date()  # Chuyển thành date

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
                            effective_date=effective_date  # Lưu dưới dạng date
                        )
                        if not session.query(Pdarticle).filter_by(id=dieu["MAPC"]).first():
                            batch.append(pdarticle)

                        for table in tables:
                            if not session.query(Pdtable).filter_by(article_id=dieu["MAPC"], html=table).first():
                                batch.append(Pdtable(article_id=dieu["MAPC"], html=table))

                        file_elem = dieu_html.parent.next_sibling
                        while file_elem and file_elem.name == "a":
                            if not session.query(Pdfile).filter_by(article_id=dieu["MAPC"], link=file_elem["href"]).first():
                                batch.append(Pdfile(article_id=dieu["MAPC"], link=file_elem["href"], path=""))
                            file_elem = file_elem.next_sibling

                        if file_elem and file_elem.name == "p" and "pChiDan" in file_elem.get("class", []):
                            for link in file_elem.select("a"):
                                if "onclick" in link.attrs and link["onclick"]:
                                    id_relation = extract_input(link["onclick"].replace("'", ""))
                                    dieus_lienquan.append({"idRelation1": dieu["MAPC"], "idRelation2": id_relation})

                        order += 1

                        if len(batch) >= BATCH_SIZE:
                            for item in batch:
                                session.add(item)
                            session.commit()
                            batch = []

                        if batch:
                            for item in batch:
                                session.add(item)
                            session.commit()

                except Exception as e:
                    session.rollback()
                    print(f"Error processing file {file_name}: {e}")

        print(f"Processed file {file_name}, total processed: {count}")

    print("Inserted all nodes!")

    with get_session() as session:
        try:
            for lienquan in dieus_lienquan:
                if not session.query(Pdrelation).filter_by(article_id1=lienquan["idRelation1"],
                                                           article_id2=lienquan["idRelation2"]).first():
                    session.add(Pdrelation(article_id1=lienquan["idRelation1"], article_id2=lienquan["idRelation2"]))
            session.commit()
        except Exception as e:
            session.rollback()
            print(f"Error inserting relations: {e}")
        finally:
            session.close()
    print("Inserted all relations!")
    pass