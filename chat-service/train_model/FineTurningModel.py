# from transformers import AutoTokenizer, AutoModelForMaskedLM, DataCollatorForLanguageModeling, Trainer, TrainingArguments
# from datasets import load_dataset
#
# # Giả sử bạn có file `law_data.json` với cột "text" chứa các đoạn văn bản luật.
# dataset = load_dataset("json", data_files="data/combined_data.json")
#
# # Chia train/eval
# dataset = dataset["train"].train_test_split(test_size=0.1)
# train_dataset = dataset["train"]
# eval_dataset = dataset["test"]
#
# # Chọn mô hình PhoBERT
# model_name = "vinai/phobert-base-v2"
# tokenizer = AutoTokenizer.from_pretrained(model_name, use_fast=False)
# model = AutoModelForMaskedLM.from_pretrained(model_name)
#
# def tokenize_function(examples):
#     return tokenizer(examples["combined_data"],
#         truncation=True,
#         padding="max_length",
#         max_length=64,
#         return_token_type_ids=False )
#
# tokenized_train = train_dataset.map(tokenize_function, batched=True, remove_columns=["combined_data"])
# tokenized_eval = eval_dataset.map(tokenize_function, batched=True, remove_columns=["combined_data"])
#
# tokenized_train.set_format("torch", columns=["input_ids", "attention_mask"])
# tokenized_eval.set_format("torch", columns=["input_ids", "attention_mask"])
#
# # Data collator cho MLM
# data_collator = DataCollatorForLanguageModeling(
#     tokenizer=tokenizer,
#     mlm=True,
#     mlm_probability=0.15
# )
#
# training_args = TrainingArguments(
#     output_dir="./finetuned_phobert",
#     evaluation_strategy="epoch",
#     learning_rate=5e-5,
#     per_device_train_batch_size=4,
#     per_device_eval_batch_size=4,
#     num_train_epochs=3,
#     weight_decay=0.01,
#     logging_steps=50,
#     save_steps=500,
#     save_total_limit=2,
#     warmup_steps=100,
#     push_to_hub=True,
#     hub_model_id="huynguyen251/finetuned-phobert-law",
#     hub_token="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",
#     hub_strategy="every_save"
# )
#
# trainer = Trainer(
#     model=model,
#     args=training_args,
#     train_dataset=tokenized_train,
#     eval_dataset=tokenized_eval,
#     data_collator=data_collator
# )
#
# trainer.train()
# trainer.save_model("./final_finetuned_model")
# tokenizer.save_pretrained("./final_finetuned_model")
#
import os
import torch
from transformers import (
    AutoTokenizer,
    AutoModelForMaskedLM,
    DataCollatorForLanguageModeling,
    Trainer,
    TrainingArguments,
    EarlyStoppingCallback
)
from datasets import load_dataset
import numpy as np

# Tắt cảnh báo TensorFlow
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

def main():
    # 1. Cấu hình thiết bị
    device = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"Đang sử dụng thiết bị: {device}")
    torch.cuda.empty_cache()

    # 2. Tải và xử lý dataset
    def load_data():
        dataset = load_dataset("json", data_files="data/combined_data.json")
        return dataset["train"].train_test_split(test_size=0.1, seed=42)

    dataset = load_data()
    train_dataset = dataset["train"]
    eval_dataset = dataset["test"]

    # 3. Khởi tạo model
    model_name = "vinai/phobert-base-v2"
    tokenizer = AutoTokenizer.from_pretrained(model_name, use_fast=False)
    model = AutoModelForMaskedLM.from_pretrained(model_name).to(device)

    # 4. Hàm tokenize
    def tokenize_function(examples):
        return tokenizer(
            text=[text.replace("_", " ").strip() for text in examples["combined_data"]],
            truncation=True,
            padding="max_length",
            max_length=256,
            return_token_type_ids=False,
            return_special_tokens_mask=True
        )

    # 5. Xử lý dataset (đã fix num_proc)
    def process_dataset(ds):
        ds = ds.map(
            tokenize_function,
            batched=True,
            batch_size=512,
            remove_columns=["combined_data"],
            num_proc=1  # Giảm xuống 1 process cho Windows
        )
        ds.set_format(type="torch", columns=["input_ids", "attention_mask", "special_tokens_mask"])
        return ds

    tokenized_train = process_dataset(train_dataset)
    tokenized_eval = process_dataset(eval_dataset)

    # 6. Data Collator
    data_collator = DataCollatorForLanguageModeling(
        tokenizer=tokenizer,
        mlm=True,
        mlm_probability=0.15,
        pad_to_multiple_of=8
    )

    # 7. Cấu hình training
    training_args = TrainingArguments(
        output_dir="./finetuned_phobert",
        evaluation_strategy="steps",
        save_strategy="steps",
        eval_steps=500,
        save_steps=500,
        learning_rate=3e-5,
        per_device_train_batch_size=8,
        gradient_accumulation_steps=2,
        num_train_epochs=10,
        fp16=True,
        gradient_checkpointing=True,
        warmup_ratio=0.1,
        logging_steps=50,
        load_best_model_at_end=True,
        metric_for_best_model="eval_loss",
        greater_is_better=False,
        push_to_hub=True,
        hub_model_id="huynguyen251/finetuned-phobert-law",
        hub_token="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",
        dataloader_num_workers=0  # Đặt thành 0 cho Windows
    )

    # 8. Trainer
    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=tokenized_train,
        eval_dataset=tokenized_eval,
        data_collator=data_collator,
        callbacks=[EarlyStoppingCallback(early_stopping_patience=3)]
    )

    # 9. Huấn luyện
    print("Bắt đầu huấn luyện...")
    trainer.train()
    print("Hoàn thành huấn luyện!")

    # 10. Lưu model
    trainer.save_model("./final_finetuned_model")
    tokenizer.save_pretrained("./final_finetuned_model")

if __name__ == "__main__":
    main()
