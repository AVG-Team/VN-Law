import openai
from app.services.LLMService import LLMService
import os
import sys

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../')))

class ChatbotService:
    def __init__(self):
        openai.api_key = os.getenv("OPENAI_API_KEY", "your-api-key-here")
        self.llm_service = LLMService()

    def generate_response(self, answer: str, question: str, context: str) -> str:
        """
        Gửi câu trả lời từ LLM lên GPT để viết lại câu trả lời rõ ràng, hợp lý.
        """
        if not answer:
            return "Xin lỗi, tôi không thể trả lời câu hỏi của bạn."

        prompt = f"""
            Bạn là một trợ lý pháp lý thân thiện, có nhiệm vụ hỗ trợ người dân Việt Nam hiểu rõ các quy định pháp luật.

            Nội dung đã được trích xuất từ văn bản pháp luật:
            \"\"\"{context}\"\"\"

            Câu hỏi của người dân là:
            \"\"\"{question}\"\"\"

            Dưới đây là nội dung câu trả lời:
            \"\"\"{answer}\"\"\"

            Hãy thực hiện các bước sau:
            1. Đánh giá xem câu trả lời này có phù hợp với câu hỏi không và không cần trả ra cho tôi biết là có phù hợp hay không.
            2. Nếu câu trả lời không phù hợp với câu hỏi, hãy viết lại câu trả lời từ đầu sao cho:
                - Trả lời đúng theo quy định pháp luật hiện hành tại Việt Nam.
                - Trả lời rõ ràng, ngắn gọn, dễ hiểu với người dân không chuyên luật.
                - Sử dụng ngôn ngữ thân thiện, lịch sự như một người trợ lý đang tư vấn.
                - Giải thích đơn giản nếu có thuật ngữ pháp lý khó hiểu.
                - Có thể thêm ví dụ minh họa ngắn gọn để người dân dễ hình dung (nếu cần thiết).
            3. Nếu câu trả lời đã phù hợp, hãy viết lại câu trả lời sao cho thân thiện, dễ hiểu và lịch sự hơn:
                - Dùng ngôn ngữ thân thiện, dễ tiếp cận.
                - Giải thích các thuật ngữ khó hiểu một cách đơn giản.
                - Nếu cần thiết, thêm ví dụ minh họa để người dân dễ hình dung.
            4. Câu hỏi của người dân có khớp với nội dung văn bản pháp luật không? Nếu không, hãy trả lời là "Không có thông tin trong văn bản pháp luật để trả lời câu hỏi này.". (Đây là một phần quan trọng để đảm bảo câu trả lời đúng trọng tâm. Nếu câu hỏi sai do với nội dung câu hỏi là hãy trả lời như trên luôn ).
            Câu trả lời của bạn cần phải đúng và phù hợp với yêu cầu trên.
            Tôi chỉ cần nhận được là câu trả lời của câu hỏi người dân đưa ra, mọi thông tin khác không cần thiết phải trả lời.
            Không cần nói gì về câu hỏi hay câu trả lời sai hay đúng chỉ cần câu trả lời thôi nhé.
            """
        try:
            response = openai.ChatCompletion.create(
                model="gpt-4",  # hoặc "gpt-3.5-turbo"
                messages=[
                    {"role": "system", "content": "Bạn là một trợ lý pháp lý thông minh và lịch sự."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.7,
                max_tokens=300,
                top_p=0.9
            )
            return response.choices[0].message["content"].strip()

        except Exception as e:
            print(f"GPT API error: {e}")
            return "Xin lỗi, hệ thống đang gặp sự cố khi xử lý câu trả lời."
        
if __name__ == "__main__":
    # Khởi tạo ChatbotService với API key (có thể đọc từ biến môi trường hoặc truyền trực tiếp)
    chatbot = ChatbotService()

    context = """
    Điều 7. Trách nhiệm của cơ quan, tổ chức đối với thanh niên
    Cơ quan nhà nước có trách nhiệm xây dựng, tổ chức thực hiện chính sách đối với thanh niên.
    Mặt trận Tổ quốc Việt Nam, tổ chức chính trị - xã hội phối hợp với Nhà nước chăm lo, phát huy vai trò của thanh niên.
    Cơ sở giáo dục, đào tạo tạo môi trường học tập, rèn luyện, phát triển toàn diện cho thanh niên.
    Doanh nghiệp, tổ chức kinh tế có trách nhiệm tạo việc làm, đào tạo nghề cho thanh niên.
    """

    # Nhập câu hỏi từ người dùng
    question = "Tô lâm có bị phạt không?"

    # Sử dụng LLM để tạo câu trả lời ban đầu (từ RAG + LLM)
    raw_answer = chatbot.llm_service.answer_question(question,context)

    # Đưa câu trả lời thô vào GPT để chỉnh sửa lại
    final_response = chatbot.generate_response(raw_answer,question,context)

    # Hiển thị kết quả
    print("\n🧠 Trợ lý pháp lý trả lời:")
    print(final_response)

    
