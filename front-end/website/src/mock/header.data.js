import Logo from "../assets/images/logo/logo-circle.png";
import LegalDoc from "../assets/images/lottie/legalDoc.json";

export const pages = [
    { key: "1", name: "Trang chủ", href: "#", current: true },
    { key: "2", name: "VBPL", href: "/van-ban-quy-pham-phap-luat", current: false },
    { key: "3", name: "Pháp Điển", href: "/phap-dien", current: false },
    { key: "4", name: "ChatBot", href: "/chatbot", current: false },
    { key: "5", name: "Tính năng khác", href: "#", current: false },
];

export const menus = [
    { key: "1", name: "Trang cá nhân", href: "#" },
    { key: "2", name: "Cài đặt", href: "#" },
    { key: "3", name: "Đăng xuất", href: "#" },
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

export const toggleButton = [
    { id: 1, name: "Đăng nhập", link: "/dang-nhap" },
    { id: 2, name: "Đăng ký", link: "/dang-ky" },
];
