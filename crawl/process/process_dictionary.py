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
            else:
                print(f"Topic {chude['Value']} already exists, skipping.")
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
            else:
                print(f"Subject {demuc['Value']} already exists, skipping.")
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
    BATCH_SIZE = 5
    batch_ids = set()  # Thêm set để track ID trong batch hiện tại

    for file_name in os.listdir(SUBJECT_DIRECTORY):
        count += 1
        print(f"Starting to process file: {file_name} ({count}/{len(os.listdir(SUBJECT_DIRECTORY))})")

        with open(os.path.join(SUBJECT_DIRECTORY, file_name), "r", encoding='utf-8') as demuc_file:
            print(f"Reading HTML content from {file_name}")
            demuc_html = BeautifulSoup(demuc_file.read(), "html.parser")
            demuc_nodes = [node for node in json_tree_nodes if node["DeMucID"] == file_name.split(".")[0]]

            with get_session() as session:
                try:
                    # Xử lý chương
                    print(f"Processing chapters for {file_name}")
                    chapter_nodes = [n for n in demuc_nodes if
                                     n["TEN"].startswith("Chương ") or n["TEN"].startswith("Phần ")]
                    chapters_data = []
                    order = 10
                    processed_chapter_ids = set()
                    for chuong in chapter_nodes:
                        if chuong["MAPC"] in processed_chapter_ids:
                            print(f"Skipping duplicate chapter in current session: {chuong['MAPC']} - {chuong['TEN']}")
                            continue

                        if session.query(Pdchapter).filter_by(id=chuong["MAPC"]).first():
                            print(f"Skipping existing chapter in database: {chuong['MAPC']} - {chuong['TEN']}")
                            continue

                        order_val = order if chuong["TEN"].startswith("Phần ") else convert_roman_to_num(chuong["ChiMuc"])
                        chuong_data = Pdchapter(
                            id=chuong["MAPC"],
                            name=chuong["TEN"],
                            index=chuong["ChiMuc"],
                            order=order_val,
                            subject_id=chuong["DeMucID"]
                        )
                        print(f"Adding chapter: {chuong['MAPC']} - {chuong['TEN']}")
                        session.add(chuong_data)
                        chapters_data.append(chuong_data)
                        processed_chapter_ids.add(chuong["MAPC"])  # Thêm ID vào set để track

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
                            print(f"Adding default chapter: {chuong_data.id}")
                            session.add(chuong_data)
                        chapters_data.append(chuong_data)
                    print(f"Committing chapters for {file_name}")
                    session.commit()

                    # Xử lý điều
                    print(f"Processing articles for {file_name}")
                    article_nodes = [n for n in demuc_nodes if n not in chapter_nodes]
                    order = 10
                    batch = []
                    batch_ids.clear()  # Reset batch_ids cho mỗi file mới

                    for i, dieu in enumerate(article_nodes, 1):
                        print(f"Processing article {i}/{len(article_nodes)}: {dieu['MAPC']}")

                        # Kiểm tra trùng lặp trong cả database và batch hiện tại
                        if dieu["MAPC"] in batch_ids or session.query(Pdarticle).filter_by(id=dieu["MAPC"]).first():
                            print(f"Skipping duplicate article: {dieu['MAPC']}")
                            continue

                        if len(chapters_data) == 1:
                            dieu["ChuongID"] = chapters_data[0].id
                        else:
                            for chuong in chapters_data:
                                if dieu["MAPC"].startswith(chuong.id):
                                    dieu["ChuongID"] = chuong.id
                                    break

                        dieu_html = demuc_html.select_one(f'a[name="{dieu["MAPC"]}"]')
                        if not dieu_html:
                            print(f"Skipping article {dieu['MAPC']} - No HTML anchor found")
                            continue

                        name = str(dieu_html.next_sibling)
                        note_html = dieu_html.parent.next_sibling
                        vbqppl = note_html.text if note_html else ""
                        vbqppl_link = note_html.select_one("a")["href"] if note_html and note_html.select_one(
                            "a") else None

                        effective_date = None
                        if vbqppl:
                            match = re.search(r"có hiệu lực thi hành kể từ ngày (\d{2}/\d{2}/\d{4})", vbqppl)
                            if match:
                                date_str = match.group(1)
                                effective_date = datetime.strptime(date_str, "%d/%m/%Y").date()

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

                        if len(content_str) > 1000000:  # Nếu content > 1MB
                            print(f"Committing large article: {dieu['MAPC']} (content size: {len(content_str)})")
                            session.add(pdarticle)
                            session.commit()
                        else:
                            print(f"Adding article to batch: {dieu['MAPC']}")
                            batch.append(pdarticle)
                            batch_ids.add(dieu["MAPC"])

                        for table in tables:
                            if not session.query(Pdtable).filter_by(article_id=dieu["MAPC"], html=table).first():
                                print(f"Adding table for article: {dieu['MAPC']}")
                                batch.append(Pdtable(article_id=dieu["MAPC"], html=table))

                        file_elem = dieu_html.parent.next_sibling
                        while file_elem and file_elem.name == "a":
                            if not session.query(Pdfile).filter_by(article_id=dieu["MAPC"],
                                                                   link=file_elem["href"]).first():
                                print(f"Adding file for article: {dieu['MAPC']} - {file_elem['href']}")
                                batch.append(Pdfile(article_id=dieu["MAPC"], link=file_elem["href"], path=""))
                            file_elem = file_elem.next_sibling

                        if file_elem and file_elem.name == "p" and "pChiDan" in file_elem.get("class", []):
                            for link in file_elem.select("a"):
                                if "onclick" in link.attrs and link["onclick"]:
                                    id_relation = extract_input(link["onclick"].replace("'", ""))
                                    dieus_lienquan.append({"idRelation1": dieu["MAPC"], "idRelation2": id_relation})
                                    print(f"Added relation: {dieu['MAPC']} -> {id_relation}")

                        order += 1

                        if len(batch) >= BATCH_SIZE:
                            print(f"Committing batch of {len(batch)} items for {file_name}")
                            session.bulk_save_objects(batch)
                            session.commit()
                            batch.clear()
                            batch_ids.clear()  # Reset batch_ids sau khi commit

                    # Commit các bản ghi còn lại trong batch
                    if batch:
                        print(f"Committing final batch of {len(batch)} items for {file_name}")
                        session.bulk_save_objects(batch)
                        session.commit()
                        batch.clear()
                        batch_ids.clear()

                except Exception as e:
                    session.rollback()
                    print(f"Error processing file {file_name}: {e}")
                    raise

        print(f"Finished processing file: {file_name}, total processed: {count}")

    print("Inserted all nodes!")

    # Xử lý relations
    with get_session() as session:
        try:
            print("Processing relations...")
            for i, lienquan in enumerate(dieus_lienquan, 1):
                if not session.query(Pdrelation).filter_by(
                        article_id1=lienquan["idRelation1"],
                        article_id2=lienquan["idRelation2"]
                ).first():
                    print(
                        f"Adding relation {i}/{len(dieus_lienquan)}: {lienquan['idRelation1']} -> {lienquan['idRelation2']}")
                    session.add(Pdrelation(
                        article_id1=lienquan["idRelation1"],
                        article_id2=lienquan["idRelation2"]
                    ))
            print("Committing all relations")
            session.commit()
        except Exception as e:
            session.rollback()
            print(f"Error inserting relations: {e}")
            raise
    print("Inserted all relations!")