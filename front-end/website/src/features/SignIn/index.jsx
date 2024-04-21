import React from 'react';
import "./components/style.css";
import Box from '@mui/material/Box';
import Grid from '@mui/material/Grid';
import LoginForm from './components/LoginForm';
import Typography from '@mui/material/Typography';
import Logo from "~/assets/images/logo/logo2.png";
import CssBaseline from '@mui/material/CssBaseline';
import { createTheme, ThemeProvider } from '@mui/material/styles';

export default function SignIn(props) {
    const defaultTheme = createTheme();

    return (
        <ThemeProvider theme={defaultTheme}>
            <Grid container component="main">
                <CssBaseline />
                <Grid item xs={12} elevation={6} square>
                    <Box className="my-5 mx-4 flex flex-col items-center">
                        <Box component="img" className="logo" src={Logo} alt="Logo" />
                        <Typography component="text" variant="h6" className="font-bold text-blue-gray-950">Tri Thức Pháp Luật Việt Nam</Typography>
                        <Typography className="text-sub">Phát triển bởi AVG Team</Typography>
                        <LoginForm />
                    </Box>
                </Grid>
            </Grid>
        </ThemeProvider>
    );
}
