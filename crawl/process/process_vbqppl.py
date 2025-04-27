import pandas as pd
import requests
from bs4 import BeautifulSoup
from models.db import create_tables, get_session
from models.models import Vbqppl, Pdarticle
import re

def get_info(url):
    if url is None:
        return None
    match = re.search(r'ItemID=(\d+).*', url)
    return match.group(1) if match else None

def save_data(vbqppls):
    with get_session() as session:
        try:
            for item in vbqppls:
                existing = session.query(Vbqppl).filter_by(vbqppl_id=item.vbqppl_id).first()
                if existing:
                    existing.type = item.type
                    existing.number = item.number
                    existing.html = item.html
                    existing.content = item.content
                    session.merge(existing)
                else:
                    session.add(item)
                print(f"Saving vbqppl_id {item.vbqppl_id} to database")
            session.commit()
        except Exception as e:
            session.rollback()
            print(f"Error saving data: {e}")
        finally:
            session.close()

def process_vbqppl():
    with get_session() as session:
        df = pd.read_sql('SELECT vbqppl_link FROM pdarticle GROUP BY vbqppl_link;', con=session.bind)
        session.close()

    list_vb = [get_info(row["vbqppl_link"]) for _, row in df.iterrows()]
    list_vb = [x for x in list_vb if x]  # Loại bỏ None
    list_vb = list(dict.fromkeys(list_vb))  # Loại bỏ trùng lặp

    vbqppls = []
    count = 0
    for vbqppl_id in list_vb:
        with get_session() as session:
            vbqppl_tmp = session.query(Vbqppl).filter_by(vbqppl_id=vbqppl_id).first()
            if vbqppl_tmp:
                print(f"vbqppl_id {vbqppl_id} already exists in database")
                continue

        print(f"Get data vbqppl_id {vbqppl_id}")
        url_content = f'https://vbpl.vn/TW/Pages/vbpq-toanvan.aspx?ItemID={vbqppl_id}'
        try:
            response = requests.get(url_content, timeout=100)
            if response.status_code != 200:
                print(f"Failed to fetch {vbqppl_id}: HTTP {response.status_code}, URL: {url_content}")
                continue

            print(f"Fetching {url_content}")
            soup = BeautifulSoup(response.content, 'html.parser')
            toanvan = soup.find('div', id="toanvancontent")
            if not toanvan:
                with open(r'./data/vbqppl_error.txt', 'a') as f:
                    f.write(f"{vbqppl_id}\n")
                print(f"Error fetching vbqppl_id {vbqppl_id}: No 'div#toanvancontent' found")
                continue

            # Tìm div.fulltext làm nội dung chính
            print("Finding div.fulltext")
            div_text = soup.select_one('div.fulltext')
            content_html = div_text if div_text else toanvan  # Nếu không có div.fulltext, dùng toanvan

            print("Processing content")
            # Xử lý type
            type_html = None
            if toanvan.find("table"):
                next_elem = toanvan.find("table").next_sibling
                if next_elem and next_elem.name == "p" and next_elem.get("align") == "center":
                    type_html = next_elem
                elif next_elem and next_elem.next_sibling:
                    type_html = next_elem.next_sibling
            else:
                # Tìm <p align="center"> đầu tiên trong toanvan
                center_p = toanvan.find("p", align="center")
                if center_p:
                    if "<br>" in center_p.text:
                        type_html = center_p.find("strong") or center_p
                    else:
                        type_html = center_p.find("span") or center_p

            # Xử lý number từ table trong div.fulltext hoặc toanvan
            print("Finding table")
            table_html = content_html.find("table") if content_html else None
            number = None
            if table_html:
                divs = table_html.find_all("div")
                if len(divs) > 2 and ": " in divs[2].text:
                    number = divs[2].text.split(": ")[1]
                elif divs:
                    number = divs[-1].text  # Lấy div cuối nếu không có ": "

            print("Creating Vbqppl object")
            vbqppl = Vbqppl(
                vbqppl_id=vbqppl_id,
                content=content_html.text if content_html else toanvan.text,
                html=str(content_html) if content_html else str(toanvan),
                type=type_html.text if type_html else "",
                number=number if number else ""
            )
            vbqppls.append(vbqppl)

            if count % 10 == 0:
                save_data(vbqppls)
                vbqppls.clear()
            count += 1
            print(f"Processed {count}")
        except Exception as e:
            print(f"Error fetching vbqppl_id {vbqppl_id}: {str(e)}")
            continue

    # Lưu các bản ghi còn lại
    save_data(vbqppls)
    print("Successfully completed")