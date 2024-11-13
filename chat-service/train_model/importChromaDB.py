import pandas as pd 
import chromadb 
import numpy as np
import ast 
from tqdm import tqdm  # Import tqdm for the progress bar
from chromadb.config import Settings

# Load data from CSV 
data = pd.read_csv('data/data_with_embeddings.csv')

# Initialize ChromaDB client with specified storage directory
chroma_client = chromadb.Client(Settings(persist_directory="data/chromadb"))

# Create or connect to a collection 
collection_name = "vnlaw_embeddings"
collection = chroma_client.get_or_create_collection(collection_name)

# Convert the 'embedding' column from string to a list of floats
def parse_embedding(embedding_str):
    return np.array(ast.literal_eval(embedding_str)).tolist()

# Apply conversion to the 'embedding' column 
data['embedding'] = data['embedding'].apply(parse_embedding)

# Insert embeddings into ChromaDB with progress tracking
print("Starting to add data to ChromaDB...")
for idx, row in tqdm(data.iterrows(), total=len(data), desc="Adding documents to ChromaDB"):
    collection.add(
        ids=[str(idx)],  # Unique ID for each document
        documents=[row['combined_data']],
        embeddings=[row['embedding']],
        metadatas=[{"id": str(idx)}]
    )

print("Data with embeddings successfully stored in ChromaDB.")
