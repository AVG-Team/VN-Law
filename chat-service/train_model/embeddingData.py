# generate_embeddings.py

import pandas as pd
from transformers import AutoTokenizer, AutoModel
import torch
import argparse

# Define function to load data from CSV or JSON
def load_data(file_path, file_type):
    if file_type == "csv":
        data = pd.read_csv(file_path)
    elif file_type == "json":
        data = pd.read_json(file_path, lines=True)
    else:
        raise ValueError("Unsupported file type. Use 'csv' or 'json'.")
    return data

# Define function to generate embeddings
def generate_embedding(text, tokenizer, model):
    inputs = tokenizer(text, return_tensors="pt", truncation=True, padding=True)
    with torch.no_grad():
        outputs = model(**inputs)
    embedding = outputs.last_hidden_state.mean(dim=1)
    return embedding[0].numpy()

# Define function to save data with embeddings
def save_data(data, output_file, output_type):
    if output_type == "csv":
        # Convert embeddings to strings for CSV export
        data['embedding'] = data['embedding'].apply(lambda x: ','.join(map(str, x)))
        data.to_csv(output_file, index=False)
    elif output_type == "json":
        data.to_json(output_file, orient="records", lines=True)
    else:
        raise ValueError("Unsupported output file type. Use 'csv' or 'json'.")

def main(input_file, input_type, output_file, output_type, text_column):
    # Load the pre-trained embedding model
    model_name = "sentence-transformers/all-MiniLM-L6-v2"
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModel.from_pretrained(model_name)
    
    # Load the data
    print(f"Loading data from {input_file}...")
    data = load_data(input_file, input_type)
    
    # Ensure the text column exists in the data
    if text_column not in data.columns:
        raise ValueError(f"Text column '{text_column}' not found in the data.")

    # Generate embeddings for each text entry
    print("Generating embeddings...")
    data['embedding'] = data[text_column].apply(lambda x: generate_embedding(x, tokenizer, model))
    
    # Save the data with embeddings
    print(f"Saving data with embeddings to {output_file}...")
    save_data(data, output_file, output_type)
    print("Done!")

if __name__ == "__main__":
    # Set up argument parsing
    parser = argparse.ArgumentParser(description="Generate embeddings for text data and save to file.")
    parser.add_argument("--input_file", type=str, required=True, help="Path to the input file (CSV or JSON).")
    parser.add_argument("--input_type", type=str, choices=["csv", "json"], required=True, help="Type of the input file (csv or json).")
    parser.add_argument("--output_file", type=str, required=True, help="Path to the output file.")
    parser.add_argument("--output_type", type=str, choices=["csv", "json"], required=True, help="Type of the output file (csv or json).")
    parser.add_argument("--text_column", type=str, default="combined_data", help="Name of the column containing text data.")
    
    args = parser.parse_args()
    
    # Run the main function
    main(args.input_file, args.input_type, args.output_file, args.output_type, args.text_column)
