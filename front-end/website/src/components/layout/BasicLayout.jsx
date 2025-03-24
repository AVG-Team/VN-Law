import Cookies from "js-cookie";
import Footer from "~/components/ui/Footer";
import Header from "~/components/ui/Header";
import { StorageKeys } from "~/common/constants/keys.js";
import { Navigate, useLocation } from "react-router-dom";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

export default function BasicLayout({ element }) {
    const location = useLocation();
    const isAuthenticated = Cookies.get(StorageKeys.ACCESS_TOKEN);
    const authRoutes = ["/dang-nhap", "/dang-ky"];
    if (isAuthenticated && authRoutes.includes(location.pathname)) {
        return <Navigate to="/" replace />;
    }

    return (
        <div className="flex flex-col min-h-screen">
            <ToastContainer />
            <Header />
            <main className="flex-grow">{element}</main>
            <Footer />
        </div>
    );
}
