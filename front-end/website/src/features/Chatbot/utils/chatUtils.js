export const STORAGE_KEY = "legalwise_chat_history";
export const MAX_HISTORY_ITEMS = 10;

export const sampleResponses = {
    greetings: [
        "Xin chào! Tôi là trợ lý AI của LegalWise. Tôi có thể giúp gì cho bạn?",
        "Chào bạn! Tôi là trợ lý pháp lý AI. Bạn cần tư vấn về vấn đề gì?",
        "Xin chào! Tôi là trợ lý AI chuyên về pháp luật. Bạn cần hỗ trợ gì?",
    ],
    default: [
        "Tôi hiểu câu hỏi của bạn. Để tôi phân tích và đưa ra câu trả lời phù hợp.",
        "Đây là một câu hỏi thú vị. Hãy để tôi giải thích chi tiết.",
        "Tôi sẽ giúp bạn hiểu rõ hơn về vấn đề này.",
    ],
    error: "Xin lỗi, tôi không thể xử lý yêu cầu của bạn lúc này. Vui lòng thử lại sau.",
};

export const processResponse = (message) => {
    const lowerMessage = message.toLowerCase();
    const greetingKeywords = ["xin chào", "chào", "hello", "hi", "hey"];
    const shortMessage = message.length < 5;

    if (greetingKeywords.some((keyword) => lowerMessage.includes(keyword))) {
        return sampleResponses.greetings[Math.floor(Math.random() * sampleResponses.greetings.length)];
    }

    if (shortMessage) {
        return "Bạn có thể đặt câu hỏi chi tiết hơn không? Điều này sẽ giúp tôi trả lời chính xác hơn.";
    }

    return sampleResponses.default[Math.floor(Math.random() * sampleResponses.default.length)];
};

export const formatTimestamp = (date) => {
    return new Date(date).toLocaleTimeString("vi-VN", {
        hour: "2-digit",
        minute: "2-digit",
    });
};

export const formatDate = (date) => {
    return new Date(date).toLocaleDateString("vi-VN", {
        year: "numeric",
        month: "long",
        day: "numeric",
        hour: "2-digit",
        minute: "2-digit",
    });
};
