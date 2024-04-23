import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import { useState, React } from "react";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import Logo from "~/assets/images/logo/logo2.png";
import Typography from "@mui/material/Typography";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";

export function RegisterForm() {
    const [errors, setErrors] = useState({});
    const [showPassword, setShowPassword] = useState(false);
    const [hasValuePassword, setHasValuePassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);
    const [hasValueConfirmPassword, setHasValueConfirmPassword] = useState(false);

    const [formData, setFormData] = useState({
        username: "",
        email: "",
        password: "",
        confirmPassword: "",
    });

    function handleSubmit(e) {
        e.preventDefault();
        const data = new FormData(e.currentTarget);
        const username = data.get("username");
        const email = data.get("email");
        const password = data.get("password");
        const confirmPassword = data.get("confirm-password");

        const validationErrors = {};
        if (!username.trim()) {
            validationErrors.username = "Tên người dùng là bắt buộc";
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

        if (Object.keys(validationErrors).length === 0) {
            alert(
                `Form submitted:\nUsername: ${username}\nEmail: ${email}\nPassword: ${password}\nConfirm Password: ${confirmPassword}`,
            );
        }
    }

    function handleChange(e) {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });

        if (name === "password") {
            setHasValuePassword(value !== "");
        } else if (name === "confirm-password") {
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
            <Box component="form" validate="true" onSubmit={handleSubmit} className="flex flex-col mt-1 text-center">
                <TextField
                    margin="normal"
                    id="username"
                    type="username"
                    label="Tên người dùng"
                    name="username"
                    autoComplete="username"
                    onChange={handleChange}
                    autoFocus
                />
                {errors.username && <Box className="text-sm text-left text-red-500">{errors.username}</Box>}
                <TextField
                    margin="normal"
                    id="email"
                    type="email"
                    label="Email"
                    name="email"
                    autoComplete="email"
                    onChange={handleChange}
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
                    autoComplete="current-password"
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
                    name="confirm-password"
                    label="Nhập lại mật khẩu"
                    type={showConfirmPassword ? "text" : "password"}
                    id="confirm-password"
                    onChange={handleChange}
                    autoComplete="current-password"
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
        </Box>
    );
}
