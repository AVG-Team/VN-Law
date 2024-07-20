import React, { useEffect, useState } from "react";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { createTheme, ThemeProvider } from "@mui/material/styles";
import { useNavigate } from "react-router-dom";
import Typography from "@mui/material/Typography";
import Logo from "~/assets/images/logo/logo2.png";
import { DotLottieReact } from "@lottiefiles/dotlottie-react";
import { verifyEmail } from "../../api/auth-service/authClient";

export default function Notify(props) {
    const defaultTheme = createTheme();

    const navigate = useNavigate();
    const [message, setMessage] = useState("");
    const [type, setType] = useState("");
    const [token, setToken] = useState("");

    const title = props.title;
    useEffect(() => {
        document.title = title ? `${title}` : "Trang không tồn tại";

        const urlParams = new URLSearchParams(window.location.search);
        const typeParam = urlParams.get('type');
        setType(typeParam);
        setToken(urlParams.get('token'));
    }, [title]);

    useEffect(() => {
        if (type === "verifyEmailSuccess") {
            setMessage("Tài khoản của bạn đã được xác minh. Bạn có thể đăng nhập vào tài khoản của mình ngay bây giờ.");
            handleCheckVerify().then(r => console.log(r));
        } else if(type === "verifyEmail") {
            setMessage("Một email đã được gửi đến địa chỉ email của bạn. Vui lòng kiểm tra email để xác minh tài khoản của bạn.");
        } else if (type === "forgotPassword") {
            setMessage("Một email đã được gửi đến địa chỉ email của bạn. Vui lòng kiểm tra email của bạn để đặt lại mật khẩu.");
        }
    }, [type, token]);

    const handleCheckVerify = async() => {
        if (!token || !token.startsWith("AVG_") || !token.endsWith("_VNLAW")) {
            const messageToast = "Mã không hợp lệ. Vui lòng thử lại.";
            setMessage(messageToast);
            toast.error(messageToast, {
                autoClose: 1000,
                buttonClose: false
            });
            return;
        }

        try {
            const response = await verifyEmail({
                token: token,
            });
            console.log(response);
            let message = response.message;
            toast.success(message, {
                onClose: () => navigate('/'),
                autoClose: 2000,
                buttonClose: false
            });
        } catch (err) {
            toast.error(err.message);
            console.error("Error fetching server: ", err);
            setMessage(err.message);
        }
    }

    return (
        <ThemeProvider theme={defaultTheme}>
            <ToastContainer />
            <Grid container component="main" className="min-h-screen" alignItems="center" justifyContent="center">
                <Grid item xs={12} elevation={6}>
                    <Box className="mx-4 my-5">
                        <Box className="w-full px-5 py-6 mx-auto rounded shadow-2xl sm:w-8/12 lg:w-4/12">
                            <div className="mb-2 text-center">
                                <div className="flex justify-center ">
                                    <img loading="lazy" className="!w-2/4 " src={Logo} alt="Logo" />
                                </div>
                                <Typography variant="h6" className=" !text-sm italic !text-blue-gray-950">
                                    Tri Thức Pháp Luật Việt Nam
                                </Typography>
                            </div>
                            <div>
                                <DotLottieReact src="https://lottie.host/59f5e53d-ce7c-4d60-aaa9-7ba750fc86a8/OhazetStzz.json"
                                                loop autoplay direction="1" />
                            </div>
                            <Typography variant="h6" className="!text-sm !text-blue-gray-950 !text-center">
                                {message}
                            </Typography>
                        </Box>
                    </Box>
                </Grid>
            </Grid>
        </ThemeProvider>
    );
}
