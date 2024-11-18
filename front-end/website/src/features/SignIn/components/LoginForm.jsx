import { toast } from "react-toastify";
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Logo from "~/assets/images/logo/logo2.png";
import { authenticate } from "~/api/auth-service/authClient";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import ActivateAccountButton from "./ActivateAccountButton";
import Oauth2 from "../Oauth2";
import { GoogleReCaptchaProvider, GoogleReCaptcha } from "react-google-recaptcha-v3";
import Login from "../../../assets/images/lottie/login.json";
import Lottie from "lottie-react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faFacebook, faGoogle } from "@fortawesome/free-brands-svg-icons";
import { Divider } from "antd";

export default function LoginForm() {
    const navigate = useNavigate();
    const [errors, setErrors] = useState({});
    const [showPassword, setShowPassword] = useState(false);
    const [hasValuePassword, setHasValuePassword] = useState(false);
    const [recaptchaToken, setRecaptchaToken] = useState(null);
    const siteKey = import.meta.env.VITE_RECAPTCHA_SITE_KEY;
    const [loading, setLoading] = useState(false);

    const [formData, setFormData] = useState({
        email: "",
        password: "",
    });

    const handleVerify = (token) => {
        setRecaptchaToken(token);
    };

    async function handleSubmit(e) {
        e.preventDefault();

        const { email, password } = formData;

        // validate
        const validationErrors = {};

        if (!email.trim()) {
            validationErrors.email = "Email là bắt buộc";
        } else if (!/\S+@\S+\.\S+/.test(email)) {
            validationErrors.email = "Email không hợp lệ";
        }

        if (!password.trim()) {
            validationErrors.password = "Mật khẩu là bắt buộc";
        } else if (password.length < 8) {
            validationErrors.password = "Mật khẩu phải có ít nhất 8 kí tự";
        }

        setErrors(validationErrors);

        //fetch api
        if (Object.keys(validationErrors).length === 0) {
            try {
                setLoading(true);
                const response = await authenticate({
                    email: formData.email,
                    password: formData.password,
                    recaptchaToken: recaptchaToken,
                });
                toast.success(response.message, {
                    onClose: () => navigate("/"),
                    autoClose: 1000,
                });
            } catch (err) {
                toast.error(err.message, {
                    autoClose: 1000,
                });
                console.error(err.message);
            } finally {
                setLoading(false);
            }
        }
    }

    function handleChange(e) {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });

        if (name === "password") {
            setHasValuePassword(value !== "");
        }
    }

    function togglePassword() {
        setShowPassword(!showPassword);
    }

    return (
        // <Box className="px-5 mx-auto rounded shadow-2xl py-7 sm:w-6/12 lg:w-4/12">
        //     <div className="mb-2 text-center">
        //         <div className="flex justify-center ">
        //             <img loading="lazy" className="!w-2/4 " src={Logo} alt="Logo" />
        //         </div>
        //         <Typography variant="h6" className=" !text-sm italic !text-blue-gray-950">
        //             Tri Thức Pháp Luật Việt Nam
        //         </Typography>
        //     </div>
        //     <GoogleReCaptchaProvider reCaptchaKey={siteKey} language="vi">
        //     <Box component="form" validate="true" onSubmit={handleSubmit} className="mt-1 text-center">
        //         <GoogleReCaptcha onVerify={handleVerify} />
        //         <TextField
        //             margin="normal"
        //             fullWidth
        //             id="email"
        //             type="email"
        //             label="Email"
        //             name="email"
        //             autoComplete="email"
        //             autoFocus
        //             onChange={handleChange}
        //             value={formData.email}
        //             required
        //         />
        //         {errors.email && <Box className="text-sm text-left text-red-500">{errors.email}</Box>}

        //         <TextField
        //             margin="normal"
        //             fullWidth
        //             name="password"
        //             label="Mật khẩu"
        //             type={showPassword ? "text" : "password"}
        //             id="password"
        //             onChange={handleChange}
        //             autoComplete="current-password"
        //             value={formData.password}
        //             required
        //             InputProps={{
        //                 endAdornment: hasValuePassword && (
        //                     <Button onClick={togglePassword}>
        //                         {showPassword ? (
        //                             <EyeIcon className="block w-5 h-5 text-black" aria-hidden="true" />
        //                         ) : (
        //                             <EyeSlashIcon className="block w-5 h-5 text-black" aria-hidden="true" />
        //                         )}
        //                     </Button>
        //                 ),
        //             }}
        //         />
        //         {errors.password && <Box className="text-sm text-left text-red-500">{errors.password}</Box>}

        //         <Button type="submit" variant="contained" className="!mx-auto !my-8">
        //             {loading && (
        //                 <svg className="w-5 h-5 mr-3 -ml-1 text-white animate-spin" xmlns="http://www.w3.org/2000/svg"
        //                      fill="none" viewBox="0 0 24 24">
        //                     <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor"
        //                             strokeWidth="4"></circle>
        //                     <path className="opacity-75" fill="currentColor"
        //                           d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        //                 </svg>
        //             )}
        //             Đăng nhập
        //         </Button>
        //     </Box>
        //     </GoogleReCaptchaProvider>
        //     <Oauth2 />
        //     <Grid container className="justify-between">
        //         <Grid item>
        //             <Link underline="none" href="/quen-mat-khau" variant="body2">
        //                 Quên mật khẩu?
        //             </Link>
        //         </Grid>
        //         <Grid item className="flex flex-row">
        //             <Typography className="left-0 px-1 pt-[2px]" variant="body2">
        //                 Bạn không có tài khoản?
        //             </Typography>
        //             <Link underline="none" className="!mt-[2px]" href="/dang-ky" variant="body2">
        //                 Đăng ký
        //             </Link>
        //         </Grid>
        //     </Grid>
        // </Box>
        <div className="flex items-center justify-center w-full h-screen ">
            <div className="grid w-full h-full grid-cols-1 gap-4 md:grid-cols-2">
                <div className="flex flex-col items-center justify-center px-6 py-10 ">
                    <img loading="lazy" className="w-[30%]" src={Logo} alt="Logo" />
                    <p className="mt-4 text-2xl font-bold text-center text-blue-gray-800">
                        Hệ Thống Hỗ Trợ Pháp Luật Việt Nam
                    </p>
                    <span className="mt-2 text-sm text-center text-blue-gray-800">
                        Đăng nhập để sử dụng hệ thống hỗ trợ pháp lý
                    </span>
                    <div className="flex flex-col items-center justify-center w-[90%] max-w-md p-5 mt-6 bg-white border rounded-xl gap-4 shadow-md">
                        <button className="flex items-center justify-center w-full h-12 px-4 text-black bg-slate-200 rounded-xl hover:bg-slate-300">
                            <svg
                                xmlns="http://www.w3.org/2000/svg"
                                className="w-5 h-5 me-2"
                                viewBox="0 0 48 48"
                                fill="none"
                            >
                                <path
                                    fill="#EA4335"
                                    d="M24 9.5c3.67 0 6.98 1.22 9.6 3.22l7.1-7.1C35.68 2.19 30.14 0 24 0 14.64 0 6.58 5.74 2.92 13.92l8.32 6.45C13.03 13.26 17.28 9.5 24 9.5Z"
                                />
                                <path
                                    fill="#34A853"
                                    d="M48 24c0-1.57-.15-3.09-.44-4.56H24v9.44h13.44c-.58 2.89-2.23 5.3-4.68 6.95l7.4 5.72C44.42 37.33 48 31.1 48 24Z"
                                />
                                <path
                                    fill="#4A90E2"
                                    d="M6.24 14.52C3.89 19.03 3.89 24.12 6.24 28.64l8.3-6.46c-1.26-2.38-1.26-5.34 0-7.72l-8.3-6.45Z"
                                />
                                <path
                                    fill="#FBBC05"
                                    d="M24 48c6.14 0 11.68-2.19 15.7-5.92l-7.4-5.72c-2.04 1.36-4.63 2.15-8.3 2.15-6.72 0-11.97-4.76-13.76-11.4l-8.31 6.46C6.58 42.26 14.64 48 24 48Z"
                                />
                            </svg>
                            Đăng nhập bằng Google
                        </button>
                        <button className="flex items-center justify-center w-full h-12 px-4 text-black bg-slate-200 rounded-xl hover:bg-slate-300">
                            <svg
                                xmlns="http://www.w3.org/2000/svg"
                                className="w-5 h-5 me-2"
                                viewBox="0 0 48 48"
                                fill="#1877F2"
                            >
                                <path d="M36 2H12C6.48 2 2 6.48 2 12v24c0 5.52 4.48 10 10 10h12V29h-6v-7h6v-5.5c0-6.08 3.34-9.5 8.5-9.5 1.67 0 3.5.5 3.5.5v6h-3c-2.25 0-3 1.12-3 2.83V22h6l-1 7h-5v17h6c5.52 0 10-4.48 10-10V12c0-5.52-4.48-10-10-10Z" />
                            </svg>
                            Đăng nhập bằng Facebook
                        </button>
                        <Divider className="text-gray-500 text-md">Hoặc</Divider>
                        <input
                            type="email"
                            className="w-full h-12 px-4 text-gray-700 border border-gray-300 rounded-xl focus:outline-none focus:border-blue-400"
                            placeholder="Nhập email của bạn"
                        />
                        <button className="flex items-center justify-center w-full h-12 px-4 mt-3 text-white bg-blue-600 rounded-xl hover:bg-blue-700">
                            Đăng nhập / Đăng ký
                        </button>
                    </div>
                    <span className="mt-4 text-sm text-center text-gray-400">
                        Bằng việc đăng ký, bạn đồng ý với Chính sách và <br /> Điều khoản của AI Tra cứu Luật
                    </span>
                    <span className="mt-10 text-sm text-center text-gray-400">
                        Đơn vị vận hành và triển khai: <br />
                        AVG TEAM
                    </span>
                </div>

                <div className="flex items-center justify-center h-screen rounded-lg bg-gradient-to-tr from-blue-500 via-white to-blue-200">
                    <Lottie
                        style={{ width: "70%", maxWidth: "900px", height: "auto", maxHeight: "100%" }}
                        animationData={Login}
                    />
                </div>
            </div>
        </div>
    );
}
