import Logo from "../assets/images/logo/logo-circle.png";
import LegalDoc from "../assets/images/lottie/legalDoc.json";

export const pages = [
    { key: "1", name: "Pháp Điển", href: "#", current: true },
    { key: "2", name: "VBPL", href: "#", current: false },
    { key: "3", name: "ChatBot", href: "chatbot", current: false },
    { key: "4", name: "Tính năng khác", href: "#", current: false },
];

export const menus = [
    { key: "1", name: "Profile", href: "#" },
    { key: "2", name: "Settings", href: "#" },
    { key: "3", name: "Sign out", href: "#" },
];

export const banner = [
    {
        key: "1",
        title: "Tri Thức Pháp Luật Việt Nam",
        description: "Phát Triển Bởi AVG Team",
        logo: Logo,
        page: "Trang chủ",
    },
    {
        key: "2",
        title: "Danh sách văn bản pháp luật",
        description: "Tập hợp các văn bản quy phạm pháp luật của Việt Nam",
        logo: LegalDoc,
        page: "Tra cứu",
    },
    {
        key: "3",
        title: "Tri Thức Pháp Luật Việt Nam",
        description: "Phát Triển Bởi AVG Team",
        logo: Logo,
        page: "Home",
    },
    {
        key: "4",
        title: "Tri Thức Pháp Luật Việt Nam",
        description: "Phát Triển Bởi AVG Team",
        logo: Logo,
        page: "Home",
    },
];
