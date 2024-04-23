import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import { useState, React } from "react";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import Logo from "~/assets/images/logo/logo2.png";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";

export function LoginForm() {
    const [showPassword, setShowPassword] = useState(false);
    const [hasValuePassword, setHasValuePassword] = useState(false);

    const [formData, setFormData] = useState({
        email: "",
        password: "",
    });

    function handleSubmit(e) {
        e.preventDefault();
        const data = new FormData(e.currentTarget);
        const email = data.get("email");
        const password = data.get("password");
        alert(`Form submitted:\nEmail: ${email}\nPassword: ${password}`);
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
                    required
                />
                <TextField
                    margin="normal"
                    fullWidth
                    name="password"
                    label="Mật khẩu"
                    type={showPassword ? "text" : "password"}
                    id="password"
                    onChange={handleChange}
                    autoComplete="current-password"
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
