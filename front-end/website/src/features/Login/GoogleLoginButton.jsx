import React from "react";
import PropTypes from "prop-types";
import { motion } from "framer-motion";
import { Button, Modal } from "antd";
import { GoogleOAuthProvider, useGoogleLogin } from "@react-oauth/google";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import { setToken } from "../../mock/auth";

const GoogleLoginWrapper = ({ icon, text }) => {
    const navigate = useNavigate();

    const login = useGoogleLogin({
        onSuccess: async (tokenResponse) => {
            try {
                console.log("Google Access Token:", tokenResponse.access_token);
                const response = await axios.post("http://14.225.218.42:9001/api/auth/google-token", {
                    provider: "google",
                    token: tokenResponse.access_token,
                });

                console.log("Response from server:", response.data);
                if (response.data.code !== 0) {
                    console.error("Authentication failed:", response.data.message);
                    Modal.info({
                        title: "Thông báo",
                        content: "Đăng nhập thất bại. Vui lòng kiểm tra lại.",
                        okText: "Đóng",
                    });
                    return;
                }
                setToken(response.data.data);
                navigate("/");
            } catch (error) {
                console.error("Authentication failed:", error);
                Modal.info({
                    title: "Thông báo",
                    content: "Đăng nhập thất bại. Vui lòng kiểm tra lại.",
                    okText: "Đóng",
                });
            }
        },
        onError: () => {
            console.error("Google login failed");
            Modal.info({
                title: "Thông báo",
                content: "Đăng nhập thất bại. Vui lòng kiểm tra lại.",
                okText: "Đóng",
            });
        },
        scope: "openid email profile",
        flow: "implicit",
    });

    return (
        <motion.div whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.98 }}>
            <Button
                icon={icon}
                className="flex items-center justify-center w-full h-12 gap-2 transition-all duration-300 border-gray-300 hover:border-blue-500 hover:text-blue-500"
                onClick={login}
            >
                {text}
            </Button>
        </motion.div>
    );
};

const SocialButton = ({ icon, text, onClick, provider }) => {
    if (provider === "google") {
        return (
            <GoogleOAuthProvider clientId="739767436237-uglpa7ugbl215feiikhftn0ndqcllgkd.apps.googleusercontent.com">
                <GoogleLoginWrapper icon={icon} text={text} />
            </GoogleOAuthProvider>
        );
    }

    return (
        <motion.div whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.98 }}>
            <Button
                icon={icon}
                className="flex items-center justify-center w-full h-12 gap-2 transition-all duration-300 border-gray-300 hover:border-blue-500 hover:text-blue-500"
                onClick={onClick}
            >
                {text}
            </Button>
        </motion.div>
    );
};

SocialButton.propTypes = {
    icon: PropTypes.node.isRequired,
    text: PropTypes.string.isRequired,
    onClick: PropTypes.func,
    provider: PropTypes.oneOf(["google", "facebook"]),
};

export default SocialButton;
