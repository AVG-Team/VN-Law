import Cookies from "js-cookie";
import { Navigate, Outlet } from "react-router-dom";
import { StorageKeys } from "~/common/constants/keys.js";
import {ToastContainer } from 'react-toastify';
import "react-toastify/dist/ReactToastify.css";

export default function AuthLayout() {
    return !Cookies.get(StorageKeys.ACCESS_TOKEN) ? <Navigate to="/dang-nhap" replace /> :
        (
            <>
                <ToastContainer />
                <Outlet />
            </>
        );
}
