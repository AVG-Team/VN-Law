import Box from "@mui/material/Box";
import { toast } from "react-toastify";
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import { useState } from "react";
import Button from "@mui/material/Button";
import { useNavigate } from "react-router-dom";
import TextField from "@mui/material/TextField";
import Logo from "~/assets/images/logo/logo2.png";
import Typography from "@mui/material/Typography";
import { register } from "~/services/authClient";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import Oauth2 from "../../SignIn/Oauth2";
import { GoogleReCaptchaProvider, GoogleReCaptcha } from "react-google-recaptcha-v3";

export function RegisterForm() {
    const navigate = useNavigate();
    const [errors, setErrors] = useState({});
    const [showPassword, setShowPassword] = useState(false);
    const [hasValuePassword, setHasValuePassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);
    const [hasValueConfirmPassword, setHasValueConfirmPassword] = useState(false);
    const [loading, setLoading] = useState(false);
    const [formData, setFormData] = useState({
        name: "",
        email: "",
        password: "",
        confirmPassword: "",
    });
    const [recaptchaToken, setRecaptchaToken] = useState(null);
    const siteKey = import.meta.env.VITE_RECAPTCHA_SITE_KEY;

    const handleVerify = (token) => {
        setRecaptchaToken(token);
    };

    async function handleSubmit(e) {
        e.preventDefault();

        const { name, email, password, confirmPassword } = formData;

        // validate
        const validationErrors = {};
        if (!name.trim()) {
            validationErrors.name = "Tên người dùng là bắt buộc";
        }

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

        if (!confirmPassword.trim()) {
            validationErrors.confirmPassword = "Nhập lại mật khẩu là bắt buộc";
        } else if (confirmPassword !== password) {
            validationErrors.confirmPassword = "Mật khẩu không khớp";
        }

        setErrors(validationErrors);

        // fetch api
        if (Object.keys(validationErrors).length === 0) {
            try {
                setLoading(true);
                const response = await register({
                    name: formData.name,
                    email: formData.email,
                    password: formData.password,
                    recaptchaToken: recaptchaToken,
                });
                let message = response.message;
                toast.success(message, {
                    onClose: () => navigate("/dang-nhap"),
                    autoClose: 1000,
                    buttonClose: false,
                });
            } catch (err) {
                toast.error(err.message);
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
        } else if (name === "confirmPassword") {
            setHasValueConfirmPassword(value !== "");
        }
    }

    function togglePassword() {
        setShowPassword(!showPassword);
    }

    function toggleConfirmPassword() {
        setShowConfirmPassword(!showConfirmPassword);
    }

    return (
        <Box className="w-full px-5 py-6 mx-auto rounded shadow-2xl sm:w-8/12 lg:w-4/12">
            <div className="mb-2 text-center">
                <div className="flex justify-center ">
                    <img loading="lazy" className="!w-2/4 " src={Logo} alt="Logo" />
                </div>
                <Typography variant="h6" className=" !text-sm italic !text-blue-gray-950">
                    Tri Thức Pháp Luật Việt Nam
                </Typography>
            </div>
            <GoogleReCaptchaProvider reCaptchaKey={siteKey} language="vi">
                <Box
                    component="form"
                    validate="true"
                    onSubmit={handleSubmit}
                    className="flex flex-col mt-1 text-center"
                >
                    <GoogleReCaptcha onVerify={handleVerify} />
                    <TextField
                        margin="normal"
                        id="name"
                        type="name"
                        label="Tên người dùng"
                        name="name"
                        autoComplete="name"
                        onChange={handleChange}
                        value={formData.name}
                        autoFocus
                    />
                    {errors.name && <Box className="text-sm text-left text-red-500">{errors.name}</Box>}
                    <TextField
                        margin="normal"
                        id="email"
                        type="email"
                        label="Email"
                        name="email"
                        autoComplete="email"
                        onChange={handleChange}
                        value={formData.email}
                        autoFocus
                    />
                    {errors.email && <Box className="text-sm text-left text-red-500">{errors.email}</Box>}
                    <TextField
                        margin="normal"
                        name="password"
                        label="Mật khẩu"
                        type={showPassword ? "text" : "password"}
                        id="password"
                        onChange={handleChange}
                        value={formData.password}
                        autoComplete="current-password"
                        InputProps={{
                            endAdornment: hasValuePassword && (
                                <Button className="eye-button" onClick={togglePassword}>
                                    {showPassword ? (
                                        <EyeSlashIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                    ) : (
                                        <EyeIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                    )}
                                </Button>
                            ),
                        }}
                    />
                    {errors.password && <Box className="text-sm text-left text-red-500">{errors.password}</Box>}
                    <TextField
                        margin="normal"
                        name="confirmPassword"
                        label="Nhập lại mật khẩu"
                        type={showConfirmPassword ? "text" : "password"}
                        id="confirmPassword"
                        onChange={handleChange}
                        value={formData.confirmPassword}
                        autoComplete="current-password"
                        InputProps={{
                            endAdornment: hasValueConfirmPassword && (
                                <Button className="eye-button" onClick={toggleConfirmPassword}>
                                    {showConfirmPassword ? (
                                        <EyeSlashIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                    ) : (
                                        <EyeIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                    )}
                                </Button>
                            ),
                        }}
                    />
                    {errors.confirmPassword && (
                        <Box className="text-sm text-left text-red-500">{errors.confirmPassword}</Box>
                    )}
                    <Button
                        type="submit"
                        variant="contained"
                        className={`!mx-auto !my-8 transition duration-300 ease-in-out ${
                            loading ? "!bg-gray-300" : "!bg-indigo-500 hover:!bg-indigo-700"
                        }`}
                    >
                        {loading && (
                            <svg
                                className="w-5 h-5 mr-3 -ml-1 text-white animate-spin"
                                xmlns="http://www.w3.org/2000/svg"
                                fill="none"
                                viewBox="0 0 24 24"
                            >
                                <circle
                                    className="opacity-25"
                                    cx="12"
                                    cy="12"
                                    r="10"
                                    stroke="currentColor"
                                    strokeWidth="4"
                                ></circle>
                                <path
                                    className="opacity-75"
                                    fill="currentColor"
                                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                                ></path>
                            </svg>
                        )}
                        Đăng ký
                    </Button>
                    <Grid container className="justify-center mt-5">
                        <Grid item className="flex flex-row">
                            <Typography className="mr-0.5 px-1" variant="body2">
                                Bạn đã có tài khoản?
                            </Typography>
                            <Link underline="none" href="/dang-nhap" variant="body2">
                                Đăng nhập
                            </Link>
                        </Grid>
                    </Grid>
                </Box>
            </GoogleReCaptchaProvider>
            <Oauth2 />
        </Box>
    );
}
