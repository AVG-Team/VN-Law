import chatbot from "../assets/images/lottie/chatbot.json";
import legalDoc from "../assets/images/lottie/legalDoc.json";
import law from "../assets/images/lottie/law.json";
import form from "../assets/images/lottie/form.json";
import news from "../assets/images/lottie/news.json";
export const NavigatorCardData = [
    { index: 1, title: "Hỏi đáp pháp luật", animationData: chatbot, link: "/chatbot" },
    { index: 2, title: "Tra cứu Pháp điển", animationData: legalDoc, link: "/phap-dien" },
    { index: 3, title: "Tra cứu ", animationData: law, link: "/van-ban-quy-pham-phap-luat" },
    { index: 4, title: "Tin tức pháp luật", animationData: news, link: "/tin-tuc" },
    { index: 5, title: "Các bảng biểu mẫu", animationData: form, link: "/bang-bieu" },
];
