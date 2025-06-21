import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { message } from "antd";
import axios from "axios";
import Cookies from "js-cookie";
import { StorageKeys } from "~/common/constants/keys";
import { checkAuth, clearToken } from "../../mock/auth"; // Giả sử bạn đã định nghĩa StorageKeys

export default function SignOut() {
    const navigate = useNavigate();
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const handleLogout = async () => {
            try {
                // Kiểm tra accessToken
                const token = checkAuth();
                if (!token) {
                    message.warning("Bạn chưa đăng nhập.");
                    navigate("/");
                    return;
                }

                // Gọi API đăng xuất
                console.log("Access Token:", token);
                const response = await axios.post("http://14.225.218.42:9001/api/auth/logout-keycloak", {
                    token: token,
                });
                console.log("Response from server:", response.data);
                clearToken();

                message.success("Đăng xuất thành công!");
                navigate("/");
            } catch (error) {
                console.error("Lỗi khi đăng xuất:", error);
                message.error("Đăng xuất thất bại. Vui lòng thử lại.");
                navigate("/"); // Vẫn chuyển hướng về trang chủ để tránh kẹt ở trang đăng xuất
            } finally {
                setLoading(false);
            }
        };

        handleLogout();
    }, [navigate]);

    return (
        <div className="flex items-center justify-center min-h-screen">
            {loading ? <p>Đang xử lý đăng xuất...</p> : <p>Đăng xuất hoàn tất, đang chuyển hướng...</p>}
        </div>
    );
}
