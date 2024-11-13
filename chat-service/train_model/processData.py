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

# Connect to the database
def connect_db(config_database):
    try:
        engine = create_engine(f'mysql+mysqlconnector://{config_database["DB_USER"]}:{config_database["DB_PASSWORD"]}@{config_database["DB_HOST"]}:{config_database["DB_PORT"]}/{config_database["DB_NAME"]}')
        print("✅ Connected to the database")
        return engine
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None

# Load the data from the database
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
    try:
        data = pd.read_sql(query, engine)
        return data
    except Exception as e:
        print(f"Error loading data: {e}")
        return pd.DataFrame()

# Clean the data
def clean_data(data):
    data = data.dropna(subset=['topic_name', 'subject_name', 'chapter_name', 'article_content'])
    data = data.drop_duplicates(subset=['topic_name', 'subject_name', 'chapter_name', 'article_content'])
    data['topic_name'] = data['topic_name'].str.lower()
    data['subject_name'] = data['subject_name'].str.lower()
    data['chapter_name'] = data['chapter_name'].str.lower()
    data['article_content'] = data['article_content'].str.lower()
    data['article_content'] = data['article_content'].str.replace(r'[^\w\s]', '', regex=True)
    return data

# Text Normalization
def text_normalization(data):
   data['article_content'] = data['article_content'].str.replace(r'\s+', ' ', regex=True).str.strip()

# Combine the data
def combine_data(data):
   data['combined_data'] = (
    "Topic: " + data['topic_name'] + "\n" +
    "Subject: " + data['subject_name'] + "\n" +
    "Chapter: " + data['chapter_name'] + "\n" +
    "Article: " + data['article_content']
)

# Save the data
def save_data(data, engine):
    data[['topic_name', 'subject_name', 'chapter_name', 'article_content', 'combined_data']].to_json("combined_data.json", orient="records", lines=True)
    data[['topic_name', 'subject_name', 'chapter_name', 'article_content', 'combined_data']].to_csv("combined_data.csv", index=False)
    # data.to_sql("combined_data", con=engine, if_exists="replace", index=False)

def main():
    print("Process Data")
    print("-----------------------")
    print("Connecting to the database")
    engine = connect_db(CONFIG_DATABASE)
    if engine is None:
        print("Failed to connect to the database.")
        return
    print("-----------------------")
    print("Loading data")
    data = load_data(engine)
    if data.empty:
        print("No data loaded.")
        return
    print("-----------------------")
    print("Cleaning data")
    data = clean_data(data)
    print("-----------------------")
    print("Text normalization")
    text_normalization(data)
    print("-----------------------")
    print("Combining data")
    combine_data(data)
    print("-----------------------")
    print("Saving data")
    save_data(data, engine)
    print("-----------------------")

if __name__ == "__main__":
    main()
