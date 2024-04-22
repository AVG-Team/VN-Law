import React from "react";
import "./components/style.css";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import CssBaseline from "@mui/material/CssBaseline";
import { RegisterForm } from "./components/RegisterForm";
import { createTheme, ThemeProvider } from "@mui/material/styles";

export default function SignUp(props) {
    const defaultTheme = createTheme();

    return (
        <ThemeProvider theme={defaultTheme}>
            <Grid container component="main" className="min-h-screen" alignItems="center" justifyContent="center">
                <Grid item xs={12} elevation={6} square>
                    <Box className="mx-5 ">
                        <RegisterForm />
                    </Box>
                </Grid>
            </Grid>
        </ThemeProvider>
    );
}
