import Box from "@mui/material/Box";
import {toast} from 'react-toastify';
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import Button from "@mui/material/Button";
import { useLocation } from 'react-router-dom'
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import Logo from "~/assets/images/logo/logo2.png";
import { React, useState, useEffect } from "react";
import { verifyTokenResetPassword } from "../../../api/auth-service/authClient";


export function VerificationForm({ changePage, email }) {
    const [verificationCode, setVerificationCode] = useState("");

    function handleSubmit(e) {
        e.preventDefault();
        const response = verifyTokenResetPassword(email, verificationCode);
        response.then((data) => {
            console.log(data);
            toast.success(data);
            changePage("reset", email, verificationCode);
        }).catch((error) => {
            toast.error(error.response.data); 
        });
    }

    function handleChange(e){
        setVerificationCode(e.target.value);
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
                    id="verificationCode"
                    type="verificationCode"
                    value={verificationCode}
                    label="Mã xác thực"
                    name="verificationCode"
                    onChange={handleChange}
                    autoFocus
                    required
                />
                <Button type="submit" variant="contained" className="!mx-auto !my-8">
                    Xác nhận
                </Button>
            </Box>
        </Box>
    );
}
