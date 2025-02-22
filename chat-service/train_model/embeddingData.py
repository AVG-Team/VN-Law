import pandas as pd
from transformers import AutoTokenizer, AutoModel
import torch
import argparse
from tqdm import tqdm

def load_data(file_path, file_type):
    if file_type == "csv":
        data = pd.read_csv(file_path)
    elif file_type == "json":
        data = pd.read_json(file_path, lines=True)
    else:
        raise ValueError("Unsupported file type. Use 'csv' or 'json'.")
    return data

def chunk_text(text, tokenizer, max_chunk_tokens=256):
    tokens = tokenizer.tokenize(text)
    chunks = [tokens[i:i+max_chunk_tokens] for i in range(0, len(tokens), max_chunk_tokens)]
    chunk_texts = [tokenizer.convert_tokens_to_string(chunk) for chunk in chunks]
    return chunk_texts

def generate_embedding_for_chunks(text, tokenizer, model, max_chunk_tokens=256):
    chunk_texts = chunk_text(text, tokenizer, max_chunk_tokens=max_chunk_tokens)
    embeddings = []
    with torch.no_grad():
        for chunk in chunk_texts:
            inputs = tokenizer(chunk, return_tensors="pt", truncation=True, padding=True)
            outputs = model(**inputs)
            # Mean pooling
            embedding = outputs.last_hidden_state.mean(dim=1)
            embeddings.append(embedding[0])
    if len(embeddings) > 1:
        final_embedding = torch.mean(torch.stack(embeddings), dim=0).numpy()
    else:
        final_embedding = embeddings[0].numpy()
    return final_embedding

def save_data_with_embeddings(embeddings, metadata, output_file, output_type):
    # embeddings: list of numpy arrays
    # metadata: list of dicts with metadata info
    df = pd.DataFrame(metadata)
    df['embedding'] = embeddings
    if output_type == "csv":
        # convert embeddings to string
        df['embedding'] = df['embedding'].apply(lambda x: ','.join(map(str, x)))
        df.to_csv(output_file, index=False)
    elif output_type == "json":
        df.to_json(output_file, orient="records", lines=True)
    else:
        raise ValueError("Unsupported output file type. Use 'csv' or 'json'.")

def main(input_file, input_type, output_file, output_type, text_column, max_chunk_tokens):
    # Model embedding
    model_name = "sentence-transformers/all-MiniLM-L6-v2"
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModel.from_pretrained(model_name)

    print(f"Loading data from {input_file}...")
    data = load_data(input_file, input_type)

    if text_column not in data.columns:
        raise ValueError(f"Text column '{text_column}' not found in the data.")

    # Generate embeddings for each row
    print("Generating embeddings with chunking...")
    embeddings = []
    metadata_list = []
    for idx, row in tqdm(data.iterrows(), desc="Embedding texts", total=len(data)):
        text = row[text_column]
        embedding = generate_embedding_for_chunks(text, tokenizer, model, max_chunk_tokens=max_chunk_tokens)
        embeddings.append(embedding)

        # Lưu metadata từ row
        # Giả sử ta muốn lưu topic_name, subject_name, chapter_name, article_id ...
        meta = {
            "topic_id": row.get("topic_id", None),
            "topic_name": row.get("topic_name", None),
            "subject_id": row.get("subject_id", None),
            "subject_name": row.get("subject_name", None),
            "chapter_id": row.get("chapter_id", None),
            "chapter_name": row.get("chapter_name", None),
            "article_id": row.get("article_id", None),
            "original_text": text
        }
        metadata_list.append(meta)

    print(f"Saving data with embeddings to {output_file}...")
    save_data_with_embeddings(embeddings, metadata_list, output_file, output_type)
    print("Done!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate embeddings for text data with chunking and save to file.")
    parser.add_argument("--input_file", type=str, required=True, help="Path to the input file (CSV or JSON).")
    parser.add_argument("--input_type", type=str, choices=["csv", "json"], required=True, help="Type of the input file (csv or json).")
    parser.add_argument("--output_file", type=str, required=True, help="Path to the output file.")
    parser.add_argument("--output_type", type=str, choices=["csv", "json"], required=True, help="Type of the output file (csv or json).")
    parser.add_argument("--text_column", type=str, default="combined_data", help="Name of the column containing text data.")
    parser.add_argument("--max_chunk_tokens", type=int, default=256, help="Maximum number of tokens per chunk.")
    
    args = parser.parse_args()
    main(args.input_file, args.input_type, args.output_file, args.output_type, args.text_column, args.max_chunk_tokens)
