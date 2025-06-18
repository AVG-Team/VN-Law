import os
import sys
import json
import torch
import logging
import logging.handlers
import transformers
import numpy as np
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Optional
from dataclasses import dataclass
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, f1_score
from transformers import (
    AutoTokenizer, AutoModelForQuestionAnswering,
    TrainingArguments, Trainer, DataCollatorWithPadding,
    EarlyStoppingCallback
)
from datasets import Dataset, DatasetDict, load_dataset
from huggingface_hub import HfApi, login, create_repo, upload_folder
import wandb
import importlib.util
from tqdm import tqdm

print(f"Transformers version: {transformers.__version__}")
print(f"Transformers location: {importlib.util.find_spec('transformers').origin}")

# Setup logging with rotation
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.handlers.RotatingFileHandler(
            'phobert_finetuning.log',
            maxBytes=10*1024*1024,
            backupCount=5,
            encoding='utf-8'
        ),
        logging.StreamHandler()
    ]
)

try:
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')
except Exception:
    pass

logger = logging.getLogger(__name__)

@dataclass
class FineTuningConfig:
    # Model settings
    model_name: str = "vinai/phobert-base"
    model_output_dir: str = "phobert-legal-qa-finetuned"
    
    # Data settings
    data_file: str = "phobert_training_data/qa_pairs.jsonl"
    max_length: int = 512
    doc_stride: int = 128
    max_query_length: int = 64
    max_answer_length: int = 256
    
    # Training settings
    learning_rate: float = 2e-5
    num_train_epochs: int = 3
    per_device_train_batch_size: int = 4
    per_device_eval_batch_size: int = 8
    gradient_accumulation_steps: int = 4
    warmup_ratio: float = 0.1
    weight_decay: float = 0.01
    fp16: bool = True
    dataloader_num_workers: int = 4
    
    # Evaluation settings
    evaluation_strategy: str = "steps"
    eval_steps: int = 200
    save_steps: int = 200
    save_total_limit: int = 3
    load_best_model_at_end: bool = True
    metric_for_best_model: str = "eval_f1"
    greater_is_better: bool = True
    
    # Early stopping
    early_stopping_patience: int = 3
    early_stopping_threshold: float = 0.001
    
    # Logging
    logging_steps: int = 50
    report_to: Optional[str] = None  # Set to "wandb" for Weights & Biases
    run_name: str = f"phobert-legal-qa-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
    
    # Validation split
    test_size: float = 0.15
    random_state: int = 42
    
    # Hugging Face Hub settings
    push_to_hub: bool = False
    hf_token: Optional[str] = None
    hf_repo_name: str = "phobert-legal-qa-v2"
    hf_username: Optional[str] = None
    hub_model_id: Optional[str] = None
    hub_private_repo: bool = False
    commit_message: str = "Fine-tuned PhoBERT for Vietnamese Legal QA - Updated Dataset"

class LegalQADataProcessor:
    def __init__(self, config: FineTuningConfig):
        self.config = config
        self.tokenizer = AutoTokenizer.from_pretrained(config.model_name)
        if self.tokenizer.pad_token is None:
            self.tokenizer.pad_token = self.tokenizer.eos_token
    
    def load_qa_data(self) -> List[Dict]:
        """Load QA data from JSONL file using streaming."""
        data_file = Path(self.config.data_file)
        if not data_file.exists():
            logger.error(f"Data file not found: {data_file}")
            return []
        
        try:
            dataset = load_dataset('json', data_files=str(data_file), split='train')
            all_qa_pairs = [dict(item) for item in tqdm(dataset, desc="Loading QA pairs")]
            logger.info(f"Loaded {len(all_qa_pairs)} QA pairs from {data_file}")
            return all_qa_pairs
        except Exception as e:
            logger.error(f"Error loading {data_file}: {e}")
            return []
    
    def preprocess_qa_data(self, qa_pairs: List[Dict]) -> List[Dict]:
        """Preprocess QA pairs for PhoBERT training."""
        processed_data = []
        skipped_count = 0
        required_fields = {"context", "question", "answer"}
        
        for idx, qa_pair in enumerate(tqdm(qa_pairs, desc="Preprocessing QA pairs")):
            try:
                if not all(field in qa_pair for field in required_fields):
                    logger.debug(f"Skipping QA pair {idx}: missing required fields")
                    skipped_count += 1
                    continue
                
                context = qa_pair["context"].strip()
                question = qa_pair["question"].strip()
                answer = qa_pair["answer"].strip()
                category = qa_pair.get("category", "Unknown")
                
                if not context or not question or not answer:
                    logger.debug(f"Skipping QA pair {idx}: empty required fields")
                    skipped_count += 1
                    continue
                
                answer_start = context.find(answer)
                if answer_start == -1:
                    answer_start = context.lower().find(answer.lower())
                    if answer_start != -1:
                        answer = context[answer_start:answer_start + len(answer)]
                    else:
                        logger.debug(f"Skipping QA pair {idx}: answer '{answer[:50]}...' not found in context")
                        skipped_count += 1
                        continue
                
                if answer_start + len(answer) > len(context):
                    logger.debug(f"Skipping QA pair {idx}: invalid answer span")
                    skipped_count += 1
                    continue
                
                processed_data.append({
                    "id": f"qa_{idx}",
                    "context": context,
                    "question": question,
                    "answer": {
                        "text": [answer],
                        "answer_start": [answer_start]
                    },
                    "category": category
                })
            except Exception as e:
                logger.warning(f"Error processing QA pair {idx}: {e}")
                skipped_count += 1
                continue
        
        logger.info(f"Processed {len(processed_data)} valid QA pairs (skipped {skipped_count})")
        return processed_data
    
    def tokenize_function(self, examples):
        """Tokenize examples for PhoBERT (non-fast tokenizer) - Fixed version."""
        input_ids = []
        attention_mask = []
        start_positions = []
        end_positions = []

        for i in range(len(examples["question"])):
            question = examples["question"][i]
            context = examples["context"][i]
            answer = examples["answer"][i]

            # Xử lý answer
            if isinstance(answer, dict):
                answer_text = answer.get("text", [""])[0]
                answer_start_char = answer.get("answer_start", [0])[0]
            elif isinstance(answer, str):
                answer_text = answer
                answer_start_char = context.find(answer_text)
                if answer_start_char == -1:
                    answer_start_char = 0
            else:
                answer_text = ""
                answer_start_char = 0

            # Tokenize question và context riêng biệt
            question_tokens = self.tokenizer.tokenize(question)
            context_tokens = self.tokenizer.tokenize(context)
            
            # Tạo combined tokens: [CLS] + question + [SEP] + context + [SEP]
            combined_tokens = (
                [self.tokenizer.cls_token] + 
                question_tokens + 
                [self.tokenizer.sep_token] + 
                context_tokens + 
                [self.tokenizer.sep_token]
            )
            
            # Truncate nếu quá dài
            if len(combined_tokens) > self.config.max_length:
                # Tính toán số tokens có thể giữ cho context
                available_context_length = (
                    self.config.max_length - len(question_tokens) - 3  # 3 cho [CLS], [SEP], [SEP]
                )
                context_tokens = context_tokens[:available_context_length]
                combined_tokens = (
                    [self.tokenizer.cls_token] + 
                    question_tokens + 
                    [self.tokenizer.sep_token] + 
                    context_tokens + 
                    [self.tokenizer.sep_token]
                )
            
            # Convert tokens to IDs
            token_ids = self.tokenizer.convert_tokens_to_ids(combined_tokens)
            
            # Tìm vị trí answer trong context tokens
            context_start_idx = len(question_tokens) + 2  # [CLS] + question + [SEP]
            
            # Tokenize answer để tìm trong context
            answer_tokens = self.tokenizer.tokenize(answer_text)
            
            # Tìm answer span trong context tokens
            def find_sublist_in_list(main_list, sub_list):
                if not sub_list:
                    return -1
                for i in range(len(main_list) - len(sub_list) + 1):
                    if main_list[i:i+len(sub_list)] == sub_list:
                        return i
                return -1
            
            answer_start_in_context = find_sublist_in_list(context_tokens, answer_tokens)
            
            if answer_start_in_context != -1:
                start_pos = context_start_idx + answer_start_in_context
                end_pos = start_pos + len(answer_tokens) - 1
                # Đảm bảo không vượt quá độ dài sequence
                end_pos = min(end_pos, len(token_ids) - 1)
            else:
                # Nếu không tìm thấy, set về 0 (CLS token)
                start_pos = 0
                end_pos = 0
            
            start_positions.append(start_pos)
            end_positions.append(end_pos)
            
            # Padding
            while len(token_ids) < self.config.max_length:
                token_ids.append(self.tokenizer.pad_token_id)
            
            # Attention mask
            attention_masks = [1] * len(combined_tokens) + [0] * (self.config.max_length - len(combined_tokens))
            
            input_ids.append(token_ids)
            attention_mask.append(attention_masks)

        return {
            "input_ids": input_ids,
            "attention_mask": attention_mask,
            "start_positions": start_positions,
            "end_positions": end_positions
        }
    
    def prepare_datasets(self, qa_data: List[Dict]) -> DatasetDict:
        """Prepare training and validation datasets."""
        processed_data = self.preprocess_qa_data(qa_data)
        if not processed_data:
            raise ValueError("No valid QA pairs found after preprocessing")
        
        categories = [item["category"] for item in processed_data]
        
        try:
            train_data, val_data = train_test_split(
                processed_data,
                test_size=self.config.test_size,
                random_state=self.config.random_state,
                stratify=categories
            )
        except ValueError:
            logger.warning("Stratified split failed, using random split")
            train_data, val_data = train_test_split(
                processed_data,
                test_size=self.config.test_size,
                random_state=self.config.random_state
            )
        
        logger.info(f"Train size: {len(train_data)}, Validation size: {len(val_data)}")
        train_categories = [item["category"] for item in train_data]
        val_categories = [item["category"] for item in val_data]
        logger.info("Training set categories: " + 
                   ", ".join([f"{cat}: {train_categories.count(cat)}" for cat in set(train_categories)]))
        logger.info("Validation set categories: " + 
                   ", ".join([f"{cat}: {val_categories.count(cat)}" for cat in set(val_categories)]))
        
        train_dataset = Dataset.from_list(train_data)
        val_dataset = Dataset.from_list(val_data)
        
        logger.info("Tokenizing datasets...")
        columns_to_remove = ["context", "question", "answer", "category", "id"]
        train_dataset = train_dataset.map(
            self.tokenize_function,
            batched=True,
            remove_columns=columns_to_remove,
            desc="Tokenizing train dataset"
        )
        val_dataset = val_dataset.map(
            self.tokenize_function,
            batched=True,
            remove_columns=columns_to_remove,
            desc="Tokenizing validation dataset"
        )
        
        return DatasetDict({"train": train_dataset, "validation": val_dataset})

class HuggingFaceUploader:
    def __init__(self, config: FineTuningConfig):
        self.config = config
        self.api = HfApi()
    
    def login_to_hub(self) -> bool:
        """Login to Hugging Face Hub."""
        if self.config.hf_token:
            logger.info("Logging in to Hugging Face Hub...")
            try:
                login(token=self.config.hf_token)
                return True
            except Exception as e:
                logger.error(f"Failed to login with token: {e}")
                return False
        
        try:
            user_info = self.api.whoami()
            logger.info(f"Already logged in as: {user_info['name']}")
            return True
        except Exception:
            logger.warning("Not logged in to Hugging Face Hub. Please run 'huggingface-cli login' first")
            return False
    
    def create_model_card(self, training_info: Dict) -> str:
        """Create a model card for the repository."""
        return f"""---
language: vi
tags:
- phobert
- question-answering
- vietnamese
- legal-qa
- pytorch
- transformers
license: apache-2.0
datasets:
- custom-legal-qa
metrics:
- f1
- accuracy
model-index:
- name: {self.config.hf_repo_name}
  results:
  - task:
      type: question-answering
      name: Question Answering
    metrics:
    - type: f1
      value: {training_info.get('eval_result', {}).get('eval_f1', 'N/A')}
      name: F1 Score
    - type: accuracy
      value: {training_info.get('eval_result', {}).get('eval_accuracy', 'N/A')}
      name: Accuracy
---

# PhoBERT Fine-tuned for Vietnamese Legal QA

## Model Description

This model is a fine-tuned version of [vinai/phobert-base](https://huggingface.co/vinai/phobert-base) for Vietnamese legal question answering.

## Training Details

### Training Data
- **Dataset**: Custom Vietnamese Legal QA dataset
- **Total QA pairs**: {training_info.get('dataset_info', {}).get('total_qa_pairs', 'N/A')}
- **Training samples**: {training_info.get('dataset_info', {}).get('train_size', 'N/A')}
- **Validation samples**: {training_info.get('dataset_info', {}).get('validation_size', 'N/A')}
- **Categories**: {', '.join(training_info.get('dataset_info', {}).get('categories', []))}

### Training Configuration
- **Base model**: {self.config.model_name}
- **Learning rate**: {self.config.learning_rate}
- **Training epochs**: {self.config.num_train_epochs}
- **Batch size**: {self.config.per_device_train_batch_size}
- **Max sequence length**: {self.config.max_length}

### Training Results
- **Training Loss**: {training_info.get('train_result', {}).get('training_loss', 'N/A')}
- **Validation F1**: {training_info.get('eval_result', {}).get('eval_f1', 'N/A')}
- **Validation Accuracy**: {training_info.get('eval_result', {}).get('eval_accuracy', 'N/A')}

## Usage

```python
from transformers import AutoTokenizer, AutoModelForQuestionAnswering
import torch

tokenizer = AutoTokenizer.from_pretrained("{self.config.hub_model_id or self.config.hf_repo_name}")
model = AutoModelForQuestionAnswering.from_pretrained("{self.config.hub_model_id or self.config.hf_repo_name}")

question = "Quy định này áp dụng cho ai?"
context = "Thanh niên là công dân Việt Nam từ đủ 16 tuổi đến 30 tuổi."

inputs = tokenizer(question, context, return_tensors="pt", max_length=512, truncation=True)
with torch.no_grad():
    outputs = model(**inputs)

start_idx = torch.argmax(outputs.start_logits)
end_idx = torch.argmax(outputs.end_logits)
answer = tokenizer.decode(inputs["input_ids"][0][start_idx:end_idx+1])
print(f"Answer: {{answer}}")
```

## Categories

{chr(10).join([f"- {cat}" for cat in training_info.get('dataset_info', {}).get('categories', [])])}

## Limitations

This model is trained on Vietnamese legal documents and may not generalize to other domains or languages.

## Training Framework

- Framework: Transformers {training_info.get('transformers_version', '4.x')}
- Language: Vietnamese
- License: Apache 2.0
"""
    
    def create_repository(self) -> Optional[str]:
        """Create repository on Hugging Face Hub."""
        try:
            repo_id = self.config.hub_model_id or f"{self.config.hf_username}/{self.config.hf_repo_name}"
            logger.info(f"Creating repository: {repo_id}")
            create_repo(
                repo_id=repo_id,
                private=self.config.hub_private_repo,
                exist_ok=True
            )
            logger.info(f"Repository created/verified: {repo_id}")
            return repo_id
        except Exception as e:
            logger.error(f"Failed to create repository: {e}")
            return None
    
    def upload_model(self, model_path: str, training_info: Dict) -> bool:
        """Upload model to Hugging Face Hub."""
        if not self.login_to_hub():
            logger.error("Failed to login to Hugging Face Hub")
            return False
        
        try:
            repo_id = self.create_repository()
            if not repo_id:
                return False
            
            model_card = self.create_model_card(training_info)
            model_card_path = Path(model_path) / "README.md"
            with open(model_card_path, 'w', encoding='utf-8') as f:
                f.write(model_card)
            
            training_info_path = Path(model_path) / "training_info.json"
            with open(training_info_path, 'w', encoding='utf-8') as f:
                json.dump(training_info, f, ensure_ascii=False, indent=2)
            
            logger.info(f"Uploading model to {repo_id}...")
            upload_folder(
                folder_path=model_path,
                repo_id=repo_id,
                commit_message=self.config.commit_message,
                ignore_patterns=["*.log", "__pycache__", "*.pyc"]
            )
            logger.info(f"✅ Model uploaded to: https://huggingface.co/{repo_id}")
            return True
        except Exception as e:
            logger.error(f"Failed to upload model: {e}")
            return False

class LegalQATrainer:
    def __init__(self, config: FineTuningConfig):
        self.config = config
        self.tokenizer = AutoTokenizer.from_pretrained(config.model_name)
        self.model = None
        self.trainer = None
        if self.tokenizer.pad_token is None:
            self.tokenizer.pad_token = self.tokenizer.eos_token
    
    def load_model(self):
        """Load PhoBERT model for question answering."""
        logger.info(f"Loading model: {self.config.model_name}")
        self.model = AutoModelForQuestionAnswering.from_pretrained(
            self.config.model_name,
            torch_dtype=torch.float16 if self.config.fp16 else torch.float32,
        )
        self.model.resize_token_embeddings(len(self.tokenizer))
        logger.info("Model loaded successfully!")
    
    def compute_metrics(self, eval_pred):
        """Compute metrics for evaluation."""
        predictions, labels = eval_pred
        start_predictions, end_predictions = predictions
        start_labels, end_labels = labels
        
        start_accuracy = accuracy_score(start_labels, np.argmax(start_predictions, axis=1))
        end_accuracy = accuracy_score(end_labels, np.argmax(end_predictions, axis=1))
        start_f1 = f1_score(start_labels, np.argmax(start_predictions, axis=1), average='macro')
        end_f1 = f1_score(end_labels, np.argmax(end_predictions, axis=1), average='macro')
        
        return {
            "accuracy": (start_accuracy + end_accuracy) / 2,
            "f1": (start_f1 + end_f1) / 2,
            "start_accuracy": start_accuracy,
            "end_accuracy": end_accuracy,
            "start_f1": start_f1,
            "end_f1": end_f1
        }
    
    def setup_training(self, datasets: DatasetDict):
        """Setup training arguments and trainer."""
        training_args = TrainingArguments(
            output_dir=self.config.model_output_dir,
            overwrite_output_dir=True,
            num_train_epochs=self.config.num_train_epochs,
            per_device_train_batch_size=self.config.per_device_train_batch_size,
            per_device_eval_batch_size=self.config.per_device_eval_batch_size,
            gradient_accumulation_steps=self.config.gradient_accumulation_steps,
            learning_rate=self.config.learning_rate,
            weight_decay=self.config.weight_decay,
            warmup_ratio=self.config.warmup_ratio,
            fp16=self.config.fp16,
            dataloader_num_workers=self.config.dataloader_num_workers,
            evaluation_strategy=self.config.evaluation_strategy,
            eval_steps=self.config.eval_steps,
            save_steps=self.config.save_steps,
            save_total_limit=self.config.save_total_limit,
            load_best_model_at_end=self.config.load_best_model_at_end,
            metric_for_best_model=self.config.metric_for_best_model,
            greater_is_better=self.config.greater_is_better,
            logging_steps=self.config.logging_steps,
            report_to=self.config.report_to,
            run_name=self.config.run_name,
            seed=self.config.random_state,
            push_to_hub=False  # Handled by HuggingFaceUploader
        )
        
        data_collator = DataCollatorWithPadding(
            tokenizer=self.tokenizer,
            pad_to_multiple_of=8 if self.config.fp16 else None
        )
        
        self.trainer = Trainer(
            model=self.model,
            args=training_args,
            train_dataset=datasets["train"],
            eval_dataset=datasets["validation"],
            tokenizer=self.tokenizer,
            data_collator=data_collator,
            compute_metrics=self.compute_metrics,
            callbacks=[
                EarlyStoppingCallback(
                    early_stopping_patience=self.config.early_stopping_patience,
                    early_stopping_threshold=self.config.early_stopping_threshold
                )
            ]
        )
        logger.info("Training setup completed!")
    
    def train(self):
        """Start training."""
        logger.info("Starting training...")
        
        # Initialize Weights & Biases if configured
        if self.config.report_to == "wandb":
            wandb_api_key = os.getenv("WANDB_API_KEY")
            if wandb_api_key:
                wandb.login(key=wandb_api_key)
                wandb.init(
                    project="phobert-legal-qa",
                    name=self.config.run_name,
                    config=self.config.__dict__
                )
            else:
                logger.warning("WANDB_API_KEY not found in environment variables. Disabling wandb logging.")
                self.config.report_to = None
        
        train_result = self.trainer.train()
        
        logger.info("Saving final model...")
        self.trainer.save_model()
        self.tokenizer.save_pretrained(self.config.model_output_dir)
        
        logger.info("Running final evaluation...")
        eval_result = self.trainer.evaluate()
        logger.info(f"Training completed! Final loss: {train_result.training_loss:.4f}")
        logger.info(f"Final evaluation metrics: {eval_result}")
        
        if self.config.report_to == "wandb":
            wandb.finish()
        
        return train_result, eval_result


def main():
    """Fine-tune PhoBERT model for Vietnamese Legal QA and optionally upload to Hugging Face Hub."""
    try:
        config = FineTuningConfig(
            model_name="vinai/phobert-base",
            model_output_dir="phobert-legal-qa-finetuned",
            data_file="fine-tuning/phobert_training_data/qa_pairs.jsonl",
            learning_rate=2e-5,
            num_train_epochs=3,
            per_device_train_batch_size=4,
            per_device_eval_batch_size=8,
            gradient_accumulation_steps=4,
            fp16=True,
            evaluation_strategy="steps",
            eval_steps=200,
            save_steps=200,
            early_stopping_patience=3,
            max_length=512,
            test_size=0.15,
            logging_steps=50,
            report_to=None,
            push_to_hub=True,
            hf_token=os.getenv('HF_TOKEN'),
            hf_username="huynguyen251",
            hf_repo_name="phobert-legal-qa-v2",
            hub_model_id="huynguyen251/phobert-legal-qa-v2",
            hub_private_repo=False,
            commit_message="Fine-tuned PhoBERT for Vietnamese Legal QA - Updated Dataset"
        )
        
        # Check device
        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        logger.info(f"Using device: {device}")
        if torch.cuda.is_available():
            logger.info(f"GPU: {torch.cuda.get_device_name(0)}")
            logger.info(f"GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.1f} GB")
        
        # Check output directory
        output_dir = Path(config.model_output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)
        if not output_dir.is_dir() or not os.access(output_dir, os.W_OK):
            logger.error(f"Output directory {config.model_output_dir} is not writable!")
            return
        
        # Check data file
        data_file = Path(config.data_file)
        if not data_file.exists():
            logger.error(f"Data file {config.data_file} does not exist!")
            logger.info("Please ensure your JSONL data file is in the correct location.")
            return
        
        logger.info("Loading and preprocessing data...")
        data_processor = LegalQADataProcessor(config)
        qa_pairs = data_processor.load_qa_data()
        if not qa_pairs:
            logger.error("No QA data found! Check data file for valid JSONL data.")
            return
        
        datasets = data_processor.prepare_datasets(qa_pairs)
        if not datasets["train"] or not datasets["validation"]:
            logger.error("Empty training or validation dataset!")
            return
        
        logger.info("Sample QA pairs:")
        for i, sample in enumerate(qa_pairs[:3]):
            logger.info(f"Sample {i+1}:")
            logger.info(f"  Question: {sample.get('question', '')[:100]}...")
            logger.info(f"  Context: {sample.get('context', '')[:100]}...")
            logger.info(f"  Answer: {str(sample.get('answer', ''))[:100]}...")
        
        logger.info("Setting up model and training...")
        trainer = LegalQATrainer(config)
        trainer.load_model()
        trainer.setup_training(datasets)
        train_result, eval_metrics = trainer.train()
        
        # Save evaluation metrics
        output_dir = Path(config.model_output_dir)
        with open(output_dir / "eval_metrics.json", "w", encoding="utf-8") as f:
            json.dump(eval_metrics, f, ensure_ascii=False, indent=2)
        
        logger.info(f"✅ Training complete. Model saved to {config.model_output_dir}")
        
        # Upload to Hugging Face Hub if configured
        if config.push_to_hub:
            logger.info("Uploading model to Hugging Face Hub...")
            uploader = HuggingFaceUploader(config)
            training_info = {
                "eval_result": eval_metrics,
                "train_result": {"training_loss": train_result.training_loss},
                "dataset_info": {
                    "total_qa_pairs": len(qa_pairs),
                    "train_size": len(datasets["train"]),
                    "validation_size": len(datasets["validation"]),
                    "categories": list(set([item["category"] for item in qa_pairs]))
                },
                "transformers_version": transformers.__version__
            }
            success = uploader.upload_model(config.model_output_dir, training_info)
            if success:
                logger.info("✅ Model successfully uploaded to Hugging Face Hub!")
            else:
                logger.warning("❌ Failed to upload model to Hugging Face Hub")
    
    except KeyboardInterrupt:
        logger.info("Training interrupted by user")
        sys.exit(1)
    except Exception as e:
        logger.error(f"❌ Fine-tuning failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()