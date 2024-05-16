import Box from "@mui/material/Box";
import {toast} from 'react-toastify';
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import { useState, React } from "react";
import Button from "@mui/material/Button";
import { useNavigate } from 'react-router-dom'
import TextField from "@mui/material/TextField";
import Logo from "~/assets/images/logo/logo2.png";
import Typography from "@mui/material/Typography";
import { register } from '../../../api/auth-service/authClient';
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import { resetPassword } from "../../../api/auth-service/authClient";


export function ResetPasswordForm({email, verificationCode}) {
    const navigate = useNavigate();
    const [errors,setErrors] = useState({});
    const [showPassword, setShowPassword] = useState(false);
    const [hasValuePassword, setHasValuePassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);
    const [hasValueConfirmPassword, setHasValueConfirmPassword] = useState(false);
    const [formData, setFormData] = useState({
        username: "",
        email: "",
        password: "",
        confirmPassword: "",
    });
    
    async function handleSubmit(e) {
        e.preventDefault();

        const {password,confirmPassword} = formData;

        // validate
        const validationErrors = {};

        if (!password.trim()) {
            validationErrors.password = "Mật khẩu mới là bắt buộc";
        } else if (password.length < 8) {
            validationErrors.password = "Mật khẩu mới phải có ít nhất 8 kí tự";
        }

        if (!confirmPassword.trim()){
            validationErrors.confirmPassword = "Nhập lại mật khẩu mới là bắt buộc";
        } else if(confirmPassword !== password){
            validationErrors.confirmPassword = "Mật khẩu không khớp";
        }
          
        setErrors(validationErrors);

        // fetch api
        if (Object.keys(validationErrors).length === 0) {
            try {
                const response = resetPassword(email, password, verificationCode);
                response.then((data) => {
                    console.log(data);
                        toast.success(data.message, {
                            onClose: () => navigate('/dang-nhap'),
                            autoClose: 2000,
                            buttonClose: false
                        });
                }).catch((error) => {       
                                
                });
            }catch (err) {
                console.log('Fetch reset password error: ',err);
            }            
        }
    }

    function handleChange(e) {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });

        if (name === "password") {
            setHasValuePassword(value !== "");
        } else if (name === "confirmPassword") {
            setHasValueConfirmPassword(value !== "");
        }
    }

    function togglePassword() {
        setShowPassword(!showPassword);
    }

    function toggleConfirmPassword() {
        setShowConfirmPassword(!showConfirmPassword);
    }

    return (
        <Box className="w-full px-5 py-6 mx-auto rounded shadow-2xl sm:w-8/12 lg:w-4/12">
            <div className="mb-2 text-center">
                <div className="flex justify-center ">
                    <img loading="lazy" className="!w-2/4 " src={Logo} alt="Logo" />
                </div>
                <Typography variant="h6" className=" !text-sm italic !text-blue-gray-950">
                    Tri Thức Pháp Luật Việt Nam
                </Typography>
            </div>
            <Box component="form" validate="true" onSubmit={handleSubmit} className="flex flex-col mt-1 text-center">
                <TextField
                    margin="normal"
                    name="password"
                    label="Mật khẩu mới"
                    type={showPassword ? "text" : "password"}
                    id="password"
                    onChange={handleChange}
                    value={formData.password}
                    InputProps={{
                        endAdornment: hasValuePassword && (
                            <Button className="eye-button" onClick={togglePassword}>
                                {showPassword ? (
                                    <EyeIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                ) : (
                                    <EyeSlashIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                )}
                            </Button>
                        ),
                    }}
                />
                {errors.password && <Box className="text-sm text-left text-red-500">{errors.password}</Box>}
                <TextField
                    margin="normal"
                    name="confirmPassword"
                    label="Nhập lại mật khẩu mới"
                    type={showConfirmPassword ? "text" : "password"}
                    id="confirmPassword"
                    onChange={handleChange}
                    value={formData.confirmPassword}
                    InputProps={{
                        endAdornment: hasValueConfirmPassword && (
                            <Button className="eye-button" onClick={toggleConfirmPassword}>
                                {showConfirmPassword ? (
                                    <EyeIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                ) : (
                                    <EyeSlashIcon className="block w-5 h-5 text-black" aria-hidden="true" />
                                )}
                            </Button>
                        ),
                    }}
                />
                {errors.confirmPassword && (
                    <Box className="text-sm text-left text-red-500">{errors.confirmPassword}</Box>
                )}
                <Button type="submit" variant="contained" className="!mx-auto !my-8">
                    Xác nhận
                </Button>
            </Box>
        </Box>
    );
}
