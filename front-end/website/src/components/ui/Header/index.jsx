import Navbar from "../Navbar";
import HeroSection from "./components/HeroSection";

export default function Header() {
    const url = window.location.href;
    const isHomePage = url.includes("/home") || url.endsWith("/");

    return (
        <header className={`relative flex justify-center bg-white ${isHomePage ? "min-h-screen" : "min-h-16"}`}>
            <Navbar />
            {isHomePage && <HeroSection />}
        </header>
    );
}
