import Box from "@mui/material/Box";
import { toast } from "react-toastify";
import { useState } from "react";
import Button from "@mui/material/Button";
import { useNavigate } from "react-router-dom";
import TextField from "@mui/material/TextField";
import Logo from "~/assets/images/logo/logo2.png";
import Typography from "@mui/material/Typography";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import { changePassword } from "~/services/authClient";
import { GoogleReCaptchaProvider, GoogleReCaptcha } from "react-google-recaptcha-v3";
import axios from "axios";

export function ResetPasswordForm({ token }) {
    const navigate = useNavigate();
    const [errors, setErrors] = useState({});
    const [showPassword, setShowPassword] = useState(false);
    const [hasValuePassword, setHasValuePassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);
    const [hasValueConfirmPassword, setHasValueConfirmPassword] = useState(false);
    const [loading, setLoading] = useState(false);
    const [formData, setFormData] = useState({
        password: "",
        confirmPassword: "",
    });
    const [recaptchaToken, setRecaptchaToken] = useState(null);
    const siteKey = import.meta.env.VITE_RECAPTCHA_SITE_KEY;

    const handleVerify = (token) => {
        setRecaptchaToken(token);
    };

    if (token === null || token === undefined || token === "") {
        toast.error("Token phải là bắt buộc", {
            onClose: () => navigate("/dang-nhap"),
            autoClose: 1000,
            buttonClose: false,
        });
    }

    async function handleSubmit(e) {
        e.preventDefault();

        const { password, confirmPassword } = formData;

        // validate
        const validationErrors = {};

        if (!password.trim()) {
            validationErrors.password = "Mật khẩu mới là bắt buộc";
        } else if (password.length < 8) {
            validationErrors.password = "Mật khẩu mới phải có ít nhất 8 kí tự";
        }

        if (!confirmPassword.trim()) {
            validationErrors.confirmPassword = "Nhập lại mật khẩu mới là bắt buộc";
        } else if (confirmPassword !== password) {
            validationErrors.confirmPassword = "Mật khẩu không khớp";
        }

        setErrors(validationErrors);

        // fetch api
        if (Object.keys(validationErrors).length === 0) {
            try {
                setLoading(true);
                const response = await axios.post('http://localhost:9001/api/auth/change-password-with-token', {
                    password: password,
                    token: token,
                });
                console.log('Response from server:', response.data);
                let message = response.data.message;

                toast.success(message, {
                    onClose: () => navigate("/dang-nhap"),
                    autoClose: 1000,
                    buttonClose: false,
                });
            } catch (err) {
                toast.error(err.message, {
                    autoClose: 1000,
                    buttonClose: false,
                });
                console.error("Fetch reset password error: ", err.message);
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
                        name="password"
                        label="Mật khẩu mới"
                        type={showPassword ? "text" : "password"}
                        id="password"
                        onChange={handleChange}
                        value={formData.password}
                        InputProps={{
                            endAdornment: hasValuePassword && (
                                <Button className="eye-button" onClick={togglePassword}>
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
                    <TextField
                        margin="normal"
                        name="confirmPassword"
                        label="Nhập lại mật khẩu mới"
                        type={showConfirmPassword ? "text" : "password"}
                        id="confirmPassword"
                        onChange={handleChange}
                        value={formData.confirmPassword}
                        InputProps={{
                            endAdornment: hasValueConfirmPassword && (
                                <Button className="eye-button" onClick={toggleConfirmPassword}>
                                    {showConfirmPassword ? (
                                        <EyeIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                    ) : (
                                        <EyeSlashIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                    )}
                                </Button>
                            ),
                        }}
                    />
                    {errors.confirmPassword && (
                        <Box className="text-sm text-left text-red-500">{errors.confirmPassword}</Box>
                    )}
                    <Button type="submit" variant="contained" className="!mx-auto !my-8">
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
                        Xác nhận
                    </Button>
                </Box>
            </GoogleReCaptchaProvider>
        </Box>
    );
}
