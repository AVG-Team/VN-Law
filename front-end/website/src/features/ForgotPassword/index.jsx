import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import { useEffect, useState } from "react";
import {ToastContainer } from 'react-toastify';
import "react-toastify/dist/ReactToastify.css";
import { ForgotForm } from "./components/ForgotForm";
import { createTheme, ThemeProvider } from "@mui/material/styles";
import { ResetPasswordForm } from "./components/ResetPasswordForm";

export default function ForgotPassword(props) {
    const defaultTheme = createTheme();
    const [type, setType] = useState("forgot-password");
    const [token, setToken] = useState("");

    const title = props.title;
    useEffect(() => {
        document.title = title ? `${title}` : "Trang không tồn tại";
        const urlParams = new URLSearchParams(window.location.search);
        setType(urlParams.get('type'));
        setToken(urlParams.get('token'));
    }, [title]);

    function renderPage() {
        switch (type) {
            case "change-password":
                return <ResetPasswordForm token={token}/>;
            default:
                return <ForgotForm />;
        }
    }

    return (
        <ThemeProvider theme={defaultTheme}>
            <ToastContainer />
            <Grid container component="main" className="min-h-screen" alignItems="center" justifyContent="center">
                <Grid item xs={12} elevation={6} >
                    <Box className="mx-4 my-5">
                        {renderPage()}
                    </Box>
                </Grid>
            </Grid>
        </ThemeProvider>
    );
}
