import React from "react";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import {ToastContainer } from 'react-toastify';
import "react-toastify/dist/ReactToastify.css";
import { LoginForm } from "./components/LoginForm";
import { createTheme, ThemeProvider } from "@mui/material/styles";

export default function SignIn(props) {
    const defaultTheme = createTheme();

    return (
        <ThemeProvider theme={defaultTheme}>
            <ToastContainer />
            <Grid container component="main" className="min-h-screen" alignItems="center" justifyContent="center">
                <Grid item xs={12} elevation={6}>
                    <Box className="mx-4 my-5">
                        <LoginForm />
                    </Box>
                </Grid>
            </Grid>
        </ThemeProvider>
    );
}
