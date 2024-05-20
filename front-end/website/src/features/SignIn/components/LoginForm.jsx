import Box from "@mui/material/Box";
import { toast } from "react-toastify";
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import { useState, React } from "react";
import Button from "@mui/material/Button";
import { useNavigate } from "react-router-dom";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import Logo from "~/assets/images/logo/logo2.png";
import { StorageKeys } from "../../../common/constants/keys";
import { authenticate } from "../../../api/auth-service/authClient";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";

export function LoginForm() {
    const navigate = useNavigate();
    const [errors, setErrors] = useState({});
    const [showPassword, setShowPassword] = useState(false);
    const [hasValuePassword, setHasValuePassword] = useState(false);

    const [formData, setFormData] = useState({
        email: "",
        password: "",
    });

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
                const response = await authenticate({
                    email: formData.email,
                    password: formData.password,
                });
                console.log("response: ", response);
                toast.success(response.message, {
                    onClose: () => navigate("/"),
                    autoClose: 1000,
                    buttonClose: false,
                });
            } catch (err) {
                if (err.response && err.response.status === 401) {
                    toast.error(err.response);
                } else if (err.response && err.response.status === 400) {
                    toast.error(err.response);
                } else {
                    console.log("Error fetching server: ", err);
                }
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
            <Box component="form" validate="true" onSubmit={handleSubmit} className="mt-1 text-center">
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
                    Đăng nhập
                </Button>
            </Box>
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
