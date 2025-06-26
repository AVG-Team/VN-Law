import Navbar from "../Navbar";
import HeroSection from "./components/HeroSection";

export default function Header() {
    const url = window.location.href;
    const isHomePage = url.includes("/home") || url.endsWith("/");
    const isChatPage = url.includes("/chat-bot") || url.includes("/chatbot") || url.includes("/trang-khong-ton-tai");

    let minHeightClass = "";
    if (isHomePage) {
        minHeightClass = "min-h-screen";
    } else if (!isChatPage) {
        minHeightClass = "min-h-20";
    }

    return (
        <header className={`relative flex justify-center w-full bg-white ${minHeightClass}`}>
            {!isChatPage && <Navbar />}
            {isHomePage && <HeroSection />}
        </header>
    );
}
