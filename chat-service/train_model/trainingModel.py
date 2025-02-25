from transformers import AutoTokenizer, AutoModelForCausalLM, Trainer, TrainingArguments, pipeline
from datasets import load_dataset
import torch

# 1. Tải bộ dữ liệu (có thể thay thế với bộ dữ liệu của bạn)
# Ở đây mình dùng bộ dữ liệu wikitext-103 làm ví dụ
dataset = load_dataset("wikitext", "wikitext-103-raw-v1")

# 2. Tải Tokenizer và Model PhoBERT (hoặc mô hình khác)
tokenizer = AutoTokenizer.from_pretrained("vinai/phobert-base-v2")
model = AutoModelForCausalLM.from_pretrained("vinai/phobert-base-v2")

# 3. Tiền xử lý dữ liệu (Tokenize)
def tokenize_function(examples):
    # Tokenize văn bản và chuyển sang địncleh dạng tensor cho PyTorch
    tokenized = tokenizer(examples["text"], padding="max_length", truncation=True, max_length=512, return_tensors='pt')
    tokenized["labels"] = tokenized["input_ids"]  # Cung cấp labels cho Causal LM
    return {key: value.squeeze(0) for key, value in tokenized.items()}  # Squeeze extra dimensions

# Áp dụng việc token hóa cho cả train và test datasets
tokenized_datasets = dataset.map(tokenize_function, batched=True)

# 4. Cài đặt các tham số huấn luyện (Training Arguments)
training_args = TrainingArguments(
    output_dir="./results",            # Thư mục lưu kết quả
    evaluation_strategy="epoch",       # Đánh giá sau mỗi epoch
    learning_rate=5e-5,                # Tỷ lệ học
    per_device_train_batch_size=4,     # Batch size khi huấn luyện
    per_device_eval_batch_size=8,      # Batch size khi đánh giá
    num_train_epochs=3,                # Số epoch huấn luyện
    weight_decay=0.01,                 # Điều chỉnh trọng số
    logging_dir="./logs",              # Thư mục log
    logging_steps=10,                  # Log mỗi 10 bước
    save_steps=1000,                   # Lưu mô hình mỗi 1000 bước
    save_total_limit=2,                # Giới hạn số lượng mô hình đã lưu
    warmup_steps=500,                  # Warmup steps
    prediction_loss_only=True          # Chỉ tính loss trong quá trình dự đoán
)

# 5. Khởi tạo Trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_datasets["train"],
    eval_dataset=tokenized_datasets["test"],
)

# 6. Huấn luyện mô hình
trainer.train()

# 7. Lưu mô hình và tokenizer sau khi fine-tuning
model.save_pretrained("./final_model")
tokenizer.save_pretrained("./final_model")

# 8. Sử dụng mô hình đã fine-tuned để sinh văn bản
generator = pipeline("text-generation", model="./final_model", tokenizer="./final_model")

# Sinh văn bản với prompt đầu vào
output = generator("Once upon a time, in a land far away", max_length=100)

# In kết quả
print(output)
