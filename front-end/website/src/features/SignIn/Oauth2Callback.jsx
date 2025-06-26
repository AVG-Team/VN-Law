import React, { useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import axios from "axios"; // Đảm bảo import axios trực tiếp

const OAuth2Callback = () => {
    const navigate = useNavigate();
    const location = useLocation();

    useEffect(() => {
        const fetchData = async () => {
            const token = new URLSearchParams(location.search).get("token");
            if (token) {
                localStorage.setItem("token", token);
                try {
                    const response = await axios.get("http://14.225.218.42:9001/api/user/me", {
                        headers: { Authorization: `Bearer ${token}` },
                    });
                    localStorage.setItem("userInfo", JSON.stringify(response.data));
                } catch (error) {
                    console.error("Failed to fetch user info:", error);
                    navigate("/login", { replace: true });
                }
                navigate("/", { replace: true });
            } else {
                navigate("/login", { replace: true });
            }
        };

        fetchData().then((r) => r);
    }, [location, navigate]);

    return (
        <div style={{ textAlign: "center", padding: "50px" }}>
            <h2>Processing OAuth2 Login...</h2>
        </div>
    );
};

export default OAuth2Callback;
