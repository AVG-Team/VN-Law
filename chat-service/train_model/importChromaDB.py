import pandas as pd 
import chromadb 
import numpy as np
import ast 
from tqdm import tqdm 
from chromadb.config import Settings


data = pd.read_csv('data/data_with_embeddings.csv')


chroma_client = chromadb.Client(Settings(persist_directory="data/chromadb"))


collection_name = "vnlaw_embeddings"
collection = chroma_client.get_or_create_collection(collection_name)


def parse_embedding(embedding_str):
    return np.array(ast.literal_eval(embedding_str)).tolist()


data['embedding'] = data['embedding'].apply(parse_embedding)

print("Starting to add data to ChromaDB...")
for idx, row in tqdm(data.iterrows(), total=len(data), desc="Adding documents to ChromaDB"):
    collection.add(
        ids=[str(idx)], 
        documents=[row['combined_data']],
        embeddings=[row['embedding']],
        metadatas=[{"id": str(idx)}]
    )

print("Data with embeddings successfully stored in ChromaDB.")
