import json
import pandas as pd
from sqlalchemy import create_engine

CONFIG_DATABASE = {
    "DB_USER": "root",
    "DB_PASSWORD": "password",
    "DB_HOST": "localhost",
    "DB_PORT": "4000",
    "DB_NAME": "law_service"
}

def create_db_engine(config):
    engine = create_engine(
        f'mysql+mysqlconnector://{config["DB_USER"]}:{config["DB_PASSWORD"]}@{config["DB_HOST"]}:{config["DB_PORT"]}/{config["DB_NAME"]}'
    )
    return engine

def load_data(engine):
    query = """
    SELECT 
        pdtopic.id AS topic_id,
        pdtopic.name AS topic_name,
        pdsubject.id AS subject_id,
        pdsubject.name AS subject_name,
        pdchapter.id AS chapter_id,
        pdchapter.name AS chapter_name,
        pdarticle.id AS article_id,
        pdarticle.content AS article_content
    FROM 
        pdtopic
    JOIN 
        pdsubject ON pdsubject.id_topic = pdtopic.id
    JOIN 
        pdchapter ON pdchapter.id_subject = pdsubject.id
    JOIN 
        pdarticle ON pdarticle.id_chapter = pdchapter.id
    ORDER BY 
        pdtopic.id, pdsubject.id, pdchapter.id, pdarticle.id;
    """
    data = pd.read_sql(query, engine)
    return data

def clean_data(data):
    # Loại bỏ dòng thiếu thông tin
    data = data.dropna(subset=['topic_name', 'subject_name', 'chapter_name', 'article_content'])
    # Loại bỏ trùng lặp
    data = data.drop_duplicates(subset=['topic_name', 'subject_name', 'chapter_name', 'article_content'])
    # Chuyển sang lowercase
    data['topic_name'] = data['topic_name'].str.lower()
    data['subject_name'] = data['subject_name'].str.lower()
    data['chapter_name'] = data['chapter_name'].str.lower()
    data['article_content'] = data['article_content'].str.lower()
    # Loại bỏ ký tự đặc biệt
    data['article_content'] = data['article_content'].str.replace(r'[^\w\s]', '', regex=True)
    # Chuẩn hoá khoảng trắng
    data['article_content'] = data['article_content'].str.replace(r'\s+', ' ', regex=True).str.strip()
    return data

def combine_data(data):
    data['combined_data'] = (
        "Topic: " + data['topic_name'] + "\n" +
        "Subject: " + data['subject_name'] + "\n" +
        "Chapter: " + data['chapter_name'] + "\n" +
        "Article: " + data['article_content']
    )

def save_data(data):
    data[['topic_id', 'topic_name', 'subject_id', 'subject_name', 
          'chapter_id', 'chapter_name', 'article_id', 'article_content', 'combined_data']].to_json("combined_data.json", orient="records", lines=True)
    data[['topic_id', 'topic_name', 'subject_id', 'subject_name', 
          'chapter_id', 'chapter_name', 'article_id', 'article_content', 'combined_data']].to_csv("combined_data_RAG.csv", index=False)

def main():
    print("Process Data")
    print("-----------------------")
    print("Creating database engine")
    engine = create_db_engine(CONFIG_DATABASE)
    print("Database engine created.")

    print("-----------------------")
    print("Loading data from DB")
    data = load_data(engine)
    if data.empty:
        print("No data loaded. Exiting.")
        return
    print(f"Loaded {len(data)} rows of data.")

    print("-----------------------")
    print("Cleaning data")
    data = clean_data(data)
    print(f"After cleaning, {len(data)} rows remain.")

    print("-----------------------")
    print("Combining data")
    combine_data(data)

    print("-----------------------")
    print("Saving data")
    save_data(data)
    print("Data saved successfully.")

if __name__ == "__main__":
    main()
