import Cookies from "js-cookie";
import Footer from "~/components/ui/Footer";
import Header from "~/components/ui/Header";
import { StorageKeys } from "~/common/constants/keys.js";
import { Navigate, useLocation } from "react-router-dom";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { useEffect } from "react";

export default function BasicLayout({ element, title }) {
    const location = useLocation();
    const isAuthenticated = Cookies.get(StorageKeys.ACCESS_TOKEN);
    const authRoutes = ["/dang-nhap", "/dang-ky"];

    useEffect(() => {
        document.title = title || "Trang chủ";
    }, [title]);

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
