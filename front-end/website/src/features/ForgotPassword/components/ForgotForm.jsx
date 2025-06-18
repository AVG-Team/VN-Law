import { toast } from "react-toastify";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import { React, useState } from "react";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import Logo from "~/assets/images/logo/logo2.png";
import { useNavigate } from "react-router-dom";
import axios from "axios";

export function ForgotForm() {
    const [email, setEmail] = useState("");
    const navigate = useNavigate();
    const [loading, setLoading] = useState(false);

    async function handleSubmit(e) {
        e.preventDefault();

        try {
            setLoading(true);
            const response = await axios.post('http://localhost:9001/api/auth/forgot-password', {
                email: email,
            });
            console.log('Response from server:', response.data);
            let message = response.data.message;
            toast.success(message, {
                onClose: () => navigate("/login"),
                autoClose: 2000,
                buttonClose: false,
            });
        } catch (err) {
            toast.error(err.message);
            console.error("Error fetching server: ", err);
        } finally {
            setLoading(false);
        }
    }

    function handleChange(e) {
        setEmail(e.target.value);
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
                    value={email}
                    onChange={handleChange}
                    autoComplete="email"
                    autoFocus
                    required
                />
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
            <Grid container className="justify-between">
                <Grid item className="flex flex-row">
                    <Typography className="left-0 px-1 pt-[2px]" variant="body2">
                        Bạn muốn đăng nhập?
                    </Typography>
                    <Link underline="none" className="!mt-[2px]" href="/dang-nhap" variant="body2">
                        Đăng nhập
                    </Link>
                </Grid>
            </Grid>
        </Box>
    );
}