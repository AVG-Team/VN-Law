from bs4 import BeautifulSoup
from models.db import create_tables, get_session
from models.models import Vbqppl, Indexvbqppl

def set_instance(id, vbqppl_id, index_parent, text):
    return Indexvbqppl(
        id=id,
        vbqppl_id=vbqppl_id,
        index_parent=index_parent if index_parent != -1 else None,  # -1 trong Java là null
        content=text,
        name=""
    )

def change(index_list, text, old_flag, new_flag, id, vbqppl_id, chapter_id):
    if text.strip():  # Chỉ thêm nếu text không rỗng
        if old_flag == 1 and new_flag == 2:
            index_list.append(set_instance(id, vbqppl_id, -1, text))
            print(f"Added chapter: id={id}, vbqppl_id={vbqppl_id}, text={text[:50]}...")
        elif old_flag == 2:
            index_list.append(set_instance(id, vbqppl_id, chapter_id, text))
            print(f"Added article: id={id}, vbqppl_id={vbqppl_id}, chapter_id={chapter_id}, text={text[:50]}...")

def save_data(index_list):
    if not index_list:
        print("No data to save")
        return
    with get_session() as session:
        try:
            for item in index_list:
                existing = session.query(Indexvbqppl).filter_by(id=item.id).first()
                if not existing:
                    session.add(item)
                    print(f"Saving id={item.id}, vbqppl_id={item.vbqppl_id}")
            session.commit()
            print(f"Saved {len(index_list)} records")
        except Exception as e:
            session.rollback()
            print(f"Error saving data: {e}")

def process_split_document():
    with get_session() as session:
        vbqppl_list = session.query(Vbqppl.vbqppl_id, Vbqppl.html).filter(Vbqppl.html.isnot(None)).all()

    index = []
    id_counter = 3012  # Khởi tạo id giống Java và Project 1
    count = 0

    for vbqppl_id, html_content in vbqppl_list:
        print(f"Processing vbqppl_id: {vbqppl_id}")
        try:
            soup = BeautifulSoup(html_content, 'html.parser').find('div', id="toanvancontent")
            if not soup:
                print(f"No 'toanvancontent' found for vbqppl_id: {vbqppl_id}")
                continue
            paragraphs = [p.get_text().replace('\n', '').lstrip() for p in soup.find_all('p') if p.get_text().strip()]
        except Exception as e:
            print(f"Error parsing HTML for vbqppl_id {vbqppl_id}: {e}")
            continue

        chapter_id = None
        flag = 0
        text_buffer = ""

        for para in paragraphs:
            if para.startswith("Chương") or para.startswith("CHƯƠNG"):
                if text_buffer:  # Lưu đoạn trước đó nếu có
                    change(index, text_buffer, flag, 1, id_counter, vbqppl_id, -1)
                    text_buffer = ""
                id_counter += 1
                chapter_id = id_counter + 1
                flag = 1
            elif para.startswith("Điều"):
                if text_buffer:
                    change(index, text_buffer, flag, 2, id_counter, vbqppl_id, chapter_id)
                    text_buffer = ""
                id_counter += 1
                flag = 2
            text_buffer += para + "\n"

        # Lưu đoạn cuối cùng
        if text_buffer:
            change(index, text_buffer, flag, 2, id_counter, vbqppl_id, chapter_id)

        count += 1
        print(f"Loaded: {count}")

        # Lưu dữ liệu sau mỗi vbqppl_id
        save_data(index)
        index.clear()

    # Lưu bất kỳ dữ liệu nào còn sót lại
    save_data(index)
    print("Completed")
    pass