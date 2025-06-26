from openai import OpenAI
import os
import sys
from dotenv import load_dotenv


load_dotenv()
class ChatbotService:
    def __init__(self):
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise ValueError("Missing OPENAI_API_KEY")
        self.client = OpenAI(api_key=api_key)

    def generate_response(self, context: str, question: str, answer: str, url_relate: list) -> str:
        """
        Gửi câu trả lời từ LLM lên GPT để viết lại câu trả lời rõ ràng, hợp lý.
        """
        url_relate = ", ".join(url_relate)
        if not answer:
            raise ValueError("Xin lỗi, tôi không thể trả lời câu hỏi của bạn.")

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
            responseAnswer = response.choices[0].message.content.strip()
            # responseAnswer = "Câu trả lời của chatgpt sẽ ở đây sau khi hoàn thành tích hợp API OpenAI."
            responseAnswer = responseAnswer + f"\n\nNguồn tham khảo: {url_relate}" if url_relate else responseAnswer
            return responseAnswer

        except Exception as e:
            print(f"GPT API error: {e}")
            return "Xin lỗi, tôi không thể trả lời câu hỏi của bạn do lỗi hệ thống."
