import React from 'react';
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
                <Box sx={{ my: 5, mx: 4, display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                    <Box component="img" sx={{ height: 100, width: 200 }} src={Logo} />
                    <Typography component="text" variant="h6" sx={{ fontWeight: 'bold', color: '#130f40' }}>Tri Thức Pháp Luật Việt Nam</Typography>
                    <Typography sx={{ mb: 2 }}>Phát triển bởi AVG Team</Typography>
                    <LoginForm />
                </Box>
                </Grid>
            </Grid>
        </ThemeProvider>
    );
}
