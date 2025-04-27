import chatbot from "../assets/images/lottie/chatbot.json";
import legalDoc from "../assets/images/lottie/legalDoc.json";
import law from "../assets/images/lottie/law.json";
import form from "../assets/images/lottie/form.json";
import news from "../assets/images/lottie/news.json";

export const NavigatorCardData = [
    {
        index: 1,
        title: "Hỏi đáp pháp luật",
        description: "Tương tác trực tiếp với AI để nhận tư vấn pháp luật nhanh chóng và chính xác",
        category: "Tư vấn pháp luật",
        animationData: chatbot,
        link: "/chatbot",
    },
    {
        index: 2,
        title: "Tra cứu Pháp điển",
        description: "Truy cập hệ thống văn bản pháp luật được hệ thống hóa và cập nhật thường xuyên",
        category: "Tra cứu pháp luật",
        animationData: legalDoc,
        link: "/phap-dien",
    },
    {
        index: 3,
        title: "Văn bản quy phạm pháp luật",
        description: "Tìm kiếm và tra cứu các văn bản quy phạm pháp luật mới nhất",
        category: "Văn bản pháp luật",
        animationData: law,
        link: "/van-ban-quy-pham-phap-luat",
    },
    {
        index: 4,
        title: "Biểu mẫu pháp luật",
        description: "Tải và sử dụng các biểu mẫu pháp luật thông dụng",
        category: "Biểu mẫu",
        animationData: form,
        link: "/bieu-mau",
    },
    {
        index: 5,
        title: "Tin tức pháp luật",
        description: "Cập nhật những tin tức mới nhất về pháp luật và chính sách",
        category: "Tin tức",
        animationData: news,
        link: "/tin-tuc",
    },
];
