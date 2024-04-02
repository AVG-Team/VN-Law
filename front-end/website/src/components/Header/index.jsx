import { NavbarWithMenu } from "./components/NavbarWithMenu";
import { CarouselDefault } from "./components/Carousel";
export default function Header() {
    return (
        <header>
            <NavbarWithMenu />
            <CarouselDefault />
        </header>
    );
}
