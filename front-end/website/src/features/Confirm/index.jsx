import React, { useEffect, useState } from "react";
import { DotLottieReact } from "@lottiefiles/dotlottie-react";
import Logo from "../../assets/images/logo/logo-circle.png";
import { getCurrentUser } from "~/services/authClient";
import { toast } from "react-toastify";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { message } from "antd";
// import {setToken} from "../../../services/apis/auth.js";

export default function Notify(props) {
    const navigate = useNavigate();
    const [token, setToken] = useState("");
    const [type, setType] = useState("");
    const [isVerify, setIsVerify] = useState(false);

    // eslint-disable-next-line react/prop-types
    const title = props.title;
    useEffect(() => {
        document.title = title ? `${title}` : "Trang không tồn tại";
        const urlParams = new URLSearchParams(window.location.search);
        setToken(urlParams.get("token"));
        setType(urlParams.get("type"));
    }, [title]);

    useEffect(() => {
        if (type === "verify-email-success") {
            if (token) handleCheckVerify().then();
        }
    }, [token]);

    const handleCheckVerify = async () => {
        try {
            setIsVerify(false);
            const response = await axios.post("http://14.225.218.42:9001/api/auth/confirm-email", {
                token: token,
            });
            console.log("Response from server:", response.data);
            //Todo: Alert Success
            let message = response.data.message;
            setIsVerify(true);
            toast.success(message, {
                onClose: () => navigate("/login"),
                autoClose: 2000,
                buttonClose: false,
            });
        } catch (err) {
            toast.error(err.message);
            console.error("Error fetching server: ", err);
        }
    };

    return (
        <>
            {isVerify ? (
                <div className="flex items-center justify-center min-h-screen bg-gradient-to-r from-white to-blue-600">
                    <div className="max-w-md p-8 mx-auto text-center bg-white rounded-lg shadow-2xl">
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            strokeWidth={1.5}
                            stroke="currentColor"
                            className="mx-auto mb-6 text-green-500 size-32 animate-bounce"
                        >
                            <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                d="M9 12.75 11.25 15 15 9.75M21 12c0 1.268-.63 2.39-1.593 3.068a3.745 3.745 0 0 1-1.043 3.296 3.745 3.745 0 0 1-3.296 1.043A3.745 3.745 0 0 1 12 21c-1.268 0-2.39-.63-3.068-1.593a3.746 3.746 0 0 1-3.296-1.043 3.745 3.745 0 0 1-1.043-3.296A3.745 3.745 0 0 1 3 12c0-1.268.63-2.39 1.593-3.068a3.745 3.745 0 0 1 1.043-3.296 3.746 3.746 0 0 1 3.296-1.043A3.746 3.746 0 0 1 12 3c1.268 0 2.39.63 3.068 1.593a3.746 3.746 0 0 1 3.296 1.043 3.746 3.746 0 0 1 1.043 3.296A3.745 3.745 0 0 1 21 12Z"
                            />
                        </svg>

                        <h2 className="mb-2 text-3xl font-extrabold text-gray-800">Xác Thực Thành Công!</h2>
                        <p className="mb-4 text-gray-700">
                            Cảm ơn bạn đã xác thực tài khoản. Bạn có thể tiếp tục sử dụng dịch vụ của chúng tôi.
                        </p>
                        <button
                            className="px-6 py-3 text-white transition duration-300 ease-in-out transform bg-blue-600 rounded-full hover:bg-blue-700 hover:scale-105"
                            onClick={() => (window.location.href = "/dang-nhap")}
                        >
                            Trở về trang chủ
                        </button>
                    </div>
                </div>
            ) : (
                <div className="flex items-center justify-center min-h-screen bg-gradient-to-r from-white to-blue-600">
                    <div className="max-w-md p-8 mx-auto text-center bg-white rounded-lg shadow-2xl">
                        <p className="mb-4 text-gray-700">Đang Thực Hiện Xác Minh...</p>
                    </div>
                </div>
            )}
        </>
    );
}
