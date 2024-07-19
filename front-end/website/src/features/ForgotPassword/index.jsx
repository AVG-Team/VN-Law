import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import { useState } from "react";
import {ToastContainer } from 'react-toastify';
import "react-toastify/dist/ReactToastify.css";
import { ForgotForm } from "./components/ForgotForm";
import { createTheme, ThemeProvider } from "@mui/material/styles";
import { VerificationForm } from "./components/VerificationForm";
import { ResetPasswordForm } from "./components/ResetPasswordForm";

export default function ForgotPassword(props) {
    const defaultTheme = createTheme();
    const [email, setEmail] = useState("");
    const [page, setPage] = useState("forgot");
    const [verificationCode, setVerificationCode] = useState("");

    function changePage(nextPage, emailValue = "", verificationCodeValue = "") {
        setPage(nextPage);
        setEmail(emailValue);
        setVerificationCode(verificationCodeValue);
    }

    function renderPage() {
        switch (page) {
            case "forgot":
                return <ForgotForm changePage={changePage} />;
            case "verify":
                return <VerificationForm changePage={changePage} email={email} />;
            case "reset":
                return <ResetPasswordForm email={email} verificationCode={verificationCode}/>;
            default:
                return <ForgotForm changePage={changePage} />;
        }
    }

    return (
        <ThemeProvider theme={defaultTheme}>
            <ToastContainer />
            <Grid container component="main" className="min-h-screen" alignItems="center" justifyContent="center">
                <Grid item xs={12} elevation={6} square>
                    <Box className="mx-4 my-5">
                        {renderPage()}
                    </Box>
                </Grid>
            </Grid>
        </ThemeProvider>
    );
}
