import Navbar from "../Navbar";
import HeroSection from "./components/HeroSection";

export default function Header() {
    const url = window.location.href;
    const isHomePage = url.includes("/home") || url.endsWith("/");

    return (
        <header className={`relative flex justify-center w-full bg-white ${isHomePage ? "min-h-screen" : "min-h-20"}`}>
            <Navbar />
            {isHomePage && <HeroSection />}
        </header>
    );
}
