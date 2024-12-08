import pandas as pd
import requests
import numpy as np
import ast
from tqdm import tqdm

# Đường dẫn file CSV
data = pd.read_csv('data/data_with_embeddings.csv')

def parse_embedding(embedding_str):
    return np.array(ast.literal_eval(embedding_str)).tolist()

data['embedding'] = data['embedding'].apply(parse_embedding)

collection_name = "vnlaw_embeddings"
base_url = "http://localhost:8000"

# Tạo collection nếu chưa có
print(f"Creating or getting collection '{collection_name}'...")
create_resp = requests.post(
    f"{base_url}/collections",
    json={"name": collection_name, "metadata": {}}
)

if create_resp.status_code not in [200, 201]:
    print(f"Failed to create/get collection: {create_resp.text}")
else:
    print(f"Collection '{collection_name}' is ready.")

print("Starting to add data to ChromaDB via REST API...")
for idx, row in tqdm(data.iterrows(), total=len(data), desc="Adding documents to ChromaDB"):
    payload = {
        "ids": [str(idx)],
        "documents": [row['combined_data']],
        "embeddings": [row['embedding']],
        "metadatas": [{"id": str(idx)}]
    }

    add_resp = requests.post(f"{base_url}/collections/{collection_name}/add", json=payload)
    if add_resp.status_code not in [200, 201]:
        print(f"Error adding document {idx}: {add_resp.text}")

print("Data with embeddings successfully stored in ChromaDB via REST API.")
