import Navbar from "../Navbar";
import HeroSection from "./components/HeroSection";
export default function Header() {
    return (
        <header className="relative flex justify-center min-h-screen bg-white ">
            <Navbar />
            <HeroSection />
        </header>
    );
}
