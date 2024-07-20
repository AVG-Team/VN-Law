import Box from "@mui/material/Box";
import { toast } from "react-toastify";
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import { useState } from "react";
import Button from "@mui/material/Button";
import { useNavigate } from "react-router-dom";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import Logo from "~/assets/images/logo/logo2.png";
import { authenticate } from "~/api/auth-service/authClient";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import ActivateAccountButton from "./ActivateAccountButton";
import Oauth2 from "../Oauth2";
import { GoogleReCaptchaProvider, GoogleReCaptcha } from 'react-google-recaptcha-v3';

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
        <Box className="px-5 mx-auto rounded shadow-2xl py-7 sm:w-6/12 lg:w-4/12">
            <div className="mb-2 text-center">
                <div className="flex justify-center ">
                    <img loading="lazy" className="!w-2/4 " src={Logo} alt="Logo" />
                </div>
                <Typography variant="h6" className=" !text-sm italic !text-blue-gray-950">
                    Tri Thức Pháp Luật Việt Nam
                </Typography>
            </div>
            <GoogleReCaptchaProvider reCaptchaKey={siteKey} language="vi">
            <Box component="form" validate="true" onSubmit={handleSubmit} className="mt-1 text-center">
                <GoogleReCaptcha onVerify={handleVerify} />
                <TextField
                    margin="normal"
                    fullWidth
                    id="email"
                    type="email"
                    label="Email"
                    name="email"
                    autoComplete="email"
                    autoFocus
                    onChange={handleChange}
                    value={formData.email}
                    required
                />
                {errors.email && <Box className="text-sm text-left text-red-500">{errors.email}</Box>}

                <TextField
                    margin="normal"
                    fullWidth
                    name="password"
                    label="Mật khẩu"
                    type={showPassword ? "text" : "password"}
                    id="password"
                    onChange={handleChange}
                    autoComplete="current-password"
                    value={formData.password}
                    required
                    InputProps={{
                        endAdornment: hasValuePassword && (
                            <Button onClick={togglePassword}>
                                {showPassword ? (
                                    <EyeIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                ) : (
                                    <EyeSlashIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                )}
                            </Button>
                        ),
                    }}
                />
                {errors.password && <Box className="text-sm text-left text-red-500">{errors.password}</Box>}

                <Button type="submit" variant="contained" className="!mx-auto !my-8">
                    {loading && (
                        <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg"
                             fill="none" viewBox="0 0 24 24">
                            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor"
                                    strokeWidth="4"></circle>
                            <path className="opacity-75" fill="currentColor"
                                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                    )}
                    Đăng nhập
                </Button>
            </Box>
            </GoogleReCaptchaProvider>
            <Oauth2 />
            <Grid container className="justify-between">
                <Grid item>
                    <Link underline="none" href="/quen-mat-khau" variant="body2">
                        Quên mật khẩu?
                    </Link>
                </Grid>
                <Grid item className="flex flex-row">
                    <Typography className="left-0 px-1 pt-[2px]" variant="body2">
                        Bạn không có tài khoản?
                    </Typography>
                    <Link underline="none" className="!mt-[2px]" href="/dang-ky" variant="body2">
                        Đăng ký
                    </Link>
                </Grid>
            </Grid>
        </Box>
    );
}
