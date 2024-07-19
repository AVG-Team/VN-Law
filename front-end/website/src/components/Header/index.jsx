import Banner from "./components/Banner";
import { Navbar } from "./components/Navbar";
import Headroom from "react-headroom";
export default function Header() {
    return (
        <header>
            <Navbar />
            <Banner />
        </header>
    );
}
