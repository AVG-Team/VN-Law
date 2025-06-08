from transformers import AutoTokenizer, AutoModelForQuestionAnswering
import torch
import torch.nn.functional as F
import re

class LLMService:

    def __init__(self):
        self.model_name = "huynguyen251/phobert-legal-qa-v2"
        self.tokenizer = None
        self.model = None
    
    def connection_hugging_face(self):
        """
         Connects to the Hugging Face Hub and load model and tokenizer.
        """
        try:
            self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
            self.model = AutoModelForQuestionAnswering.from_pretrained(self.model_name)
            print("Connection to Hugging Face established successfully.")
        except Exception as e:
            print(f"Failed to connect to Hugging Face: {e}")        

    def process_answer(self, answer: str) -> str:
        """
        Processes the answer by removing leading and trailing whitespace.
        
        :param answer: The answer to be processed.
        :return: The processed answer.
        """
        if not answer:
            return ""
        for bad_token in ["<s>", "</s>", "<pad>", "<unk>", "<mask>", "<cls>", "<sep>","@@"]:
            answer = answer.replace(bad_token, "")
        
        answer = re.sub(r'[^\w\sÀ-ỹ/\-().]', '', answer)

        answer = answer.strip()
        return answer

    def answer_question(self, question: str, context: str, threshold: float = 0.7) -> str:
        """
        Answers a question based on the provided context.
        
        :param question: The question to be answered.
        :param context: The context in which to find the answer.
        :param threshold: Confidence threshold for the answer.
        :return: The answer to the question or an empty string if confidence is below threshold.
        """
        if self.model is None or self.tokenizer is None: 
            print("Connecting to Hugging Face model...")
            self.connection_hugging_face()
        
        inputs = self.tokenizer.encode_plus(
            question,
            context,
            return_tensors='pt',
            truncation=True,
        )
        
        with torch.no_grad():
            output = self.model(**inputs)
            start_scores = output.start_logits
            end_scores = output.end_logits
        
        start_probs = F.softmax(start_scores, dim=1)
        end_probs = F.softmax(end_scores, dim=1)

        start_index = torch.argmax(start_probs)
        end_index = torch.argmax(end_probs) + 1 


        confidence = (start_probs[0][start_index] * end_probs[0][end_index - 1]).item()

        print(f"Confidence score: {confidence:.4f}")

        answer = self.tokenizer.convert_tokens_to_string(
            self.tokenizer.convert_ids_to_tokens(inputs['input_ids'][0][start_index:end_index])
        ).strip()

        answer = self.process_answer(answer)

        # Check if the answer meets the confidence threshold
        if confidence < threshold:
            return ""
        
        return answer 
    
# def main():
#     model_name = "huynguyen251/phobert-legal-qa-v2"
#     service = LLMService(model_name=model_name, hf_token=None)
#     service.connection_hugging_face()
#     print("LLMService is ready to answer questions.")
    
#     context = """
# Điều 7. Trách nhiệm của cơ quan, tổ chức đối với thanh niên

# Cơ quan nhà nước có trách nhiệm xây dựng, tổ chức thực hiện chính sách đối với thanh niên.

# Mặt trận Tổ quốc Việt Nam, tổ chức chính trị - xã hội phối hợp với Nhà nước chăm lo, phát huy vai trò của thanh niên.

# Cơ sở giáo dục, đào tạo tạo môi trường học tập, rèn luyện, phát triển toàn diện cho thanh niên.

# Doanh nghiệp, tổ chức kinh tế có trách nhiệm tạo việc làm, đào tạo nghề cho thanh niên.


#     """
#     question = "Cơ quan nhà nước có trách nhiệm xây dựng, tổ chức thực hiện chính sách đối với thanh niên thuộc điều nào trong Luật Thanh niên 2020?"
#     result = service.answer_question(question, context)
#     print("Answer:", result)


