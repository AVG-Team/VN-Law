import Cookies from "js-cookie";
import { StorageKeys } from "~/common/constants/keys.js";
import { Navigate, Outlet, useLocation } from "react-router-dom";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import Navbar from "../../components/ui/Navbar";
import Footer from "../../components/ui/Footer";

export default function ContentLayout({ element }) {
    const location = useLocation();

    return Cookies.get(StorageKeys.ACCESS_TOKEN) &&
        (location.pathname === "/dang-nhap" || location.pathname === "/dang-ky") ? (
        <Navigate to="/" replace />
    ) : (
        <div className="flex flex-col min-h-screen">
            <ToastContainer />
            <Navbar />
            {element}
            <Footer />
        </div>
    );
}
