import React, { useState } from "react";
import AppBar from "@mui/material/AppBar";
import Toolbar from "@mui/material/Toolbar";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import Menu from "@mui/material/Menu";
import MenuIcon from "@mui/icons-material/Menu";
import Container from "@mui/material/Container";
//import Avatar from "@mui/material/Avatar";
import Button from "@mui/material/Button";
//import Tooltip from "@mui/material/Tooltip";
import MenuItem from "@mui/material/MenuItem";
import Logo from "../../../assets/images/logo/logo2.png";
const pages = ["Pháp Điển", "VBPL", "Chatbot"];
const pageMobile = ["Pháp Điển", "VBPL", "Chatbot", "Sign In", "Sign Up"];
//const settings = ["Profile", "Account", "Dashboard", "Logout"];

export function Navbar() {
    const [anchorElNav, setAnchorElNav] = useState(null);
    //const [anchorElUser, setAnchorElUser] = useState(null);

    const handleOpenNavMenu = (event) => {
        setAnchorElNav(event.currentTarget);
    };
    //const handleOpenUserMenu = (event) => {
    //    setAnchorElUser(event.currentTarget);
    //};

    const handleCloseNavMenu = () => {
        setAnchorElNav(null);
    };

    //const handleCloseUserMenu = () => {
    //   setAnchorElUser(null);
    //};

    return (
        <AppBar position="sticky" className="top-0 z-50" sx={{ backgroundColor: "white !important" }}>
            <Container maxWidth="xl">
                <Toolbar className="flex items-center justify-between">
                    <a href="#dd" className="text-decoration-none">
                        <img src={Logo} alt="logo-ct" className="w-48" />
                    </a>
                    <div className="flex items-start md:hidden">
                        <IconButton
                            size="large"
                            aria-label="account of current user"
                            aria-controls="menu-appbar"
                            aria-haspopup="true"
                            onClick={handleOpenNavMenu}
                            className="text-blue-gray-900"
                        >
                            <MenuIcon />
                        </IconButton>
                        <Menu
                            id="menu-appbar"
                            anchorEl={anchorElNav}
                            anchorOrigin={{
                                vertical: "bottom",
                                horizontal: "left",
                            }}
                            keepMounted
                            transformOrigin={{
                                vertical: "top",
                                horizontal: "left",
                            }}
                            open={Boolean(anchorElNav)}
                            onClose={handleCloseNavMenu}
                        >
                            {pageMobile.map((page) => (
                                <MenuItem key={page} onClick={handleCloseNavMenu}>
                                    <Typography
                                        className="font-semibold text-blue-gray hover:!bg-blue-500"
                                        textAlign="center"
                                    >
                                        {page}
                                    </Typography>
                                </MenuItem>
                            ))}
                        </Menu>
                    </div>
                    <div className="justify-start flex-grow hidden space-x-4 md:flex">
                        {pages.map((page) => (
                            <Button
                                key={page}
                                onClick={handleCloseNavMenu}
                                className="my-2 font-semibold text-blue-gray-900"
                                sx={{ color: "rgb(15 23 42 / var(--tw-text-opacity)) !important" }}
                            >
                                {page}
                            </Button>
                        ))}
                    </div>

                    <div className="hidden md:flex">
                        <Button className="!bg-blue-gray-800 !mr-1 !rounded-lg !text-white hover:!bg-blue-gray-500">
                            Đăng nhập
                        </Button>
                        <Button className="!bg-blue-gray-800 !ml-1 !rounded-lg  !text-white hover:!bg-blue-gray-500 text-xl">
                            Đăng ký
                        </Button>
                        {/* <Tooltip title="Open settings">
                            <IconButton onClick={handleOpenUserMenu}>
                                <Avatar alt="Remy Sharp" src="/static/images/avatar/2.jpg" />
                            </IconButton>
                        </Tooltip>
                        <Menu
                            id="menu-appbar"
                            anchorEl={anchorElUser}
                            anchorOrigin={{
                                vertical: "top",
                                horizontal: "right",
                            }}
                            keepMounted
                            transformOrigin={{
                                vertical: "top",
                                horizontal: "right",
                            }}
                            open={Boolean(anchorElUser)}
                            onClose={handleCloseUserMenu}
                        >
                            {settings.map((setting) => (
                                <MenuItem key={setting} onClick={handleCloseUserMenu}>
                                    <Typography textAlign="center">{setting}</Typography>
                                </MenuItem>
                            ))}
                        </Menu> */}
                    </div>
                </Toolbar>
            </Container>
        </AppBar>
    );
}
