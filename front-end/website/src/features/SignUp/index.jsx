import React from 'react';
import "./components/style.css";
import Box from '@mui/material/Box';
import Grid from '@mui/material/Grid';
import Typography from '@mui/material/Typography';
import Logo from "~/assets/images/logo/logo2.png";
import CssBaseline from '@mui/material/CssBaseline';
import RegisterForm from './components/RegisterForm';
import { createTheme, ThemeProvider } from '@mui/material/styles';

export default function SignUp(props) {
    const defaultTheme = createTheme();

    return (
        <ThemeProvider theme={defaultTheme}>
            <Grid container component="main">
                <CssBaseline />
                <Grid item xs={12} elevation={6} square="true">
                    <Box className="mx-4 flex flex-col items-center">
                        <Box component="img" className="logo" src={Logo} alt="Logo" />
                        <Typography variant="h6" className="font-bold text-blue-gray-950">Tri Thức Pháp Luật Việt Nam</Typography>
                        <Typography className="text-sub">Phát triển bởi AVG Team</Typography>
                        <RegisterForm />
                    </Box>
                </Grid>
            </Grid>
        </ThemeProvider>
    );
}
