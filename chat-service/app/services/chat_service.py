from openai import OpenAI
from app.services import LLMService, EmbeddingService, RAGService
import os
import sys

embedding_service = EmbeddingService()
rag_service = RAGService(embedding_service=embedding_service, use_cpu=False)

class ChatbotService:
    def __init__(self):
        api_key = ""
        print(f"Using OpenAI API key: {api_key}")
        if not api_key:
            raise ValueError("Missing OPENAI_API_KEY")
        self.client = OpenAI(api_key=api_key)
        self.llm_service = LLMService()

    def generate_response(self, question: str) -> str:
        """
        Gửi câu trả lời từ LLM lên GPT để viết lại câu trả lời rõ ràng, hợp lý.
        """
        
        response = self.llm_service.answer_question(question)
        context = response['context']
        answer = response['answer'].strip()
        if not answer:
            return "Xin lỗi, tôi không thể trả lời câu hỏi của bạn."

        prompt = f"""
                Bạn là một trợ lý pháp lý thân thiện, có nhiệm vụ hỗ trợ người dân Việt Nam hiểu rõ các quy định pháp luật.

                Thông tin pháp lý được trích xuất từ văn bản:
                \"\"\"{context}\"\"\"

                Câu hỏi của người dân:
                \"\"\"{question}\"\"\"

                Câu trả lời hiện tại:
                \"\"\"{answer}\"\"\"

                Yêu cầu của bạn:

                1. Nếu nội dung câu hỏi không liên quan đến pháp luật, hãy trả lời: "Không có thông tin trong văn bản pháp luật để trả lời câu hỏi này."

                2. Nếu câu trả lời chưa đúng hoặc không phù hợp với câu hỏi, hãy viết lại câu trả lời sao cho:
                - Chính xác theo quy định pháp luật hiện hành tại Việt Nam.
                - Rõ ràng, ngắn gọn, dễ hiểu cho người không chuyên về luật.
                - Dùng ngôn ngữ thân thiện, lịch sự như một trợ lý pháp lý thực thụ.
                - Giải thích đơn giản nếu có thuật ngữ pháp lý khó hiểu.
                - Thêm ví dụ minh họa nếu cần để người dân dễ hình dung.

                3. Nếu câu trả lời đã phù hợp với câu hỏi, hãy cải thiện lại cách diễn đạt sao cho:
                - Dễ hiểu hơn, thân thiện hơn với người dân.
                - Giải thích thuật ngữ pháp lý nếu có.
                - Có thể thêm ví dụ minh họa ngắn gọn nếu cần.

                4. Tuy nhiên các câu hỏi liên quan đến các vấn đề chính trị, tôn giáo, sắc tộc, giới tính, v.v. không được trả lời.
                5. Nếu câu hỏi liên quan đến các tình huống cụ thể hoặc yêu cầu tư vấn pháp lý cá nhân, hãy trả lời theo kiến thức của bạn và đưa ra lời cảnh báo đây là "Thông tin dựa trên sự hiểu biết của tôi không phải là tư vấn pháp lý chính thức".

                Chỉ trả về câu trả lời cuối cùng, không cần giải thích, nhận xét hay đánh giá gì thêm.
                """

        try:
                response = self.client.chat.completions.create(
                model="gpt-4.1",
                messages=[
                    {"role": "system", "content": "Bạn là một trợ lý pháp lý thông minh."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.7,
                max_tokens=300,
                top_p=0.9)
                return { "answer": response.choices[0].message.content.strip(),
                            "context": context }

        except Exception as e:
            print(f"GPT API error: {e}")
            return "Xin lỗi, hệ thống đang gặp sự cố khi xử lý câu trả lời."
        