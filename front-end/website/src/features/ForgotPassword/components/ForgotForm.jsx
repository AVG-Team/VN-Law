import { React } from "react";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import Logo from "~/assets/images/logo/logo2.png";

export function ForgotForm() {
    function handleSubmit(e) {
        e.preventDefault();
        const data = new FormData(e.currentTarget);
        const email = data.get("email");
        alert(`Form submitted:\nEmail: ${email}`);
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
                    autoComplete="email"
                    autoFocus
                    required
                />
                <Button type="submit" variant="contained" className="!mx-auto !my-8">
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
