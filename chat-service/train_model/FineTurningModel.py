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
import torch
from transformers import AutoTokenizer, AutoModelForMaskedLM, DataCollatorForLanguageModeling, Trainer, TrainingArguments
from datasets import load_dataset

# Kiểm tra nếu GPU có sẵn
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"Đang sử dụng: {device}")

# Tải dataset
dataset = load_dataset("json", data_files="data/combined_data.json")

# Chia train/eval
dataset = dataset["train"].train_test_split(test_size=0.1)
train_dataset = dataset["train"]
eval_dataset = dataset["test"]

# Chọn mô hình PhoBERT
model_name = "vinai/phobert-base-v2"
tokenizer = AutoTokenizer.from_pretrained(model_name, use_fast=False)
model = AutoModelForMaskedLM.from_pretrained(model_name)

# Chuyển mô hình sang GPU
model.to(device)

# Hàm tokenize
def tokenize_function(examples):
    return tokenizer(
        examples["combined_data"],
        truncation=True,
        padding="max_length",
        max_length=64,
        return_token_type_ids=False
    )

# Tokenize dataset
tokenized_train = train_dataset.map(tokenize_function, batched=True, remove_columns=["combined_data"])
tokenized_eval = eval_dataset.map(tokenize_function, batched=True, remove_columns=["combined_data"])

tokenized_train.set_format("torch", columns=["input_ids", "attention_mask"])
tokenized_eval.set_format("torch", columns=["input_ids", "attention_mask"])

# Data collator cho MLM
data_collator = DataCollatorForLanguageModeling(
    tokenizer=tokenizer,
    mlm=True,
    mlm_probability=0.15
)

# Training Arguments
training_args = TrainingArguments(
    output_dir="./finetuned_phobert",
    evaluation_strategy="epoch",
    learning_rate=5e-5,
    per_device_train_batch_size=4,
    per_device_eval_batch_size=4,
    num_train_epochs=3,
    weight_decay=0.01,
    logging_steps=50,
    save_steps=500,
    save_total_limit=2,
    warmup_steps=100,
    push_to_hub=True,
    hub_model_id="huynguyen251/finetuned-phobert-law",
    hub_token="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",
    hub_strategy="every_save",
    report_to="none"  # Tắt báo cáo lên WandB hoặc MLflow
)

# Trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_train,
    eval_dataset=tokenized_eval,
    data_collator=data_collator
)

# Huấn luyện mô hình
trainer.train()

# Lưu mô hình và tokenizer
trainer.save_model("./final_finetuned_model")
tokenizer.save_pretrained("./final_finetuned_model")
