import React from "react";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import { LoginForm } from "./components/LoginForm";
import { createTheme, ThemeProvider } from "@mui/material/styles";

export default function SignIn(props) {
    const defaultTheme = createTheme();

    return (
        <ThemeProvider theme={defaultTheme}>
            <Grid container component="main" className="min-h-screen" alignItems="center" justifyContent="center">
                <Grid item xs={12} elevation={6} square>
                    <Box className="mx-4 my-5">
                        <LoginForm />
                    </Box>
                </Grid>
            </Grid>
        </ThemeProvider>
    );
}
