import React from 'react';
import { useState } from 'react';
import Box from '@mui/material/Box';
import Grid from '@mui/material/Grid';
import Link from '@mui/material/Link';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Typography from '@mui/material/Typography';

const EyePassword = (
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
    <path d="M15.0007 12C15.0007 13.6569 13.6576 15 12.0007 15C10.3439 15 9.00073 13.6569 9.00073 12C9.00073 10.3431 10.3439 9 12.0007 9C13.6576 9 15.0007 10.3431 15.0007 12Z" stroke="#000000" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
    <path d="M12.0012 5C7.52354 5 3.73326 7.94288 2.45898 12C3.73324 16.0571 7.52354 19 12.0012 19C16.4788 19 20.2691 16.0571 21.5434 12C20.2691 7.94291 16.4788 5 12.0012 5Z" stroke="#000000" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
  </svg>
);

const EyeClosePassword = (
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
    <path d="M2.99902 3L20.999 21M9.8433 9.91364C9.32066 10.4536 8.99902 11.1892 8.99902 12C8.99902 13.6569 10.3422 15 11.999 15C12.8215 15 13.5667 14.669 14.1086 14.133M6.49902 6.64715C4.59972 7.90034 3.15305 9.78394 2.45703 12C3.73128 16.0571 7.52159 19 11.9992 19C13.9881 19 15.8414 18.4194 17.3988 17.4184M10.999 5.04939C11.328 5.01673 11.6617 5 11.9992 5C16.4769 5 20.2672 7.94291 21.5414 12C21.2607 12.894 20.8577 13.7338 20.3522 14.5" stroke="#000000" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
  </svg>
);
  
export function RegisterForm(){
  const [errors,setErrors] = useState({});
  const [showPassword, setShowPassword] = useState(false);
  const [hasValuePassword, setHasValuePassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [hasValueConfirmPassword, setHasValueConfirmPassword] = useState(false);

  const [formData,setFormData] = useState({
    username: '',
    email: '',
    password: '',
    confirmPassword: ''
  })

  function handleSubmit(e) {
    e.preventDefault();
    const data = new FormData(e.currentTarget);
    const username = data.get('username');
    const email = data.get('email');
    const password = data.get('password');
    const confirmPassword = data.get('confirm-password');

    const validationErrors = {};
    if (!username.trim()) {
      validationErrors.username = "Tên người dùng là bắt buộc";
    }

    if (!email.trim()) {
      validationErrors.email = "Email là bắt buộc";
    } else if (!/\S+@\S+\.\S+/.test(email)) {
      validationErrors.email = "Email không hợp lệ";
    }

    if (!password.trim()) {
      validationErrors.password = "Mật khẩu là bắt buộc";
    } else if (password.length < 8) {
      validationErrors.password = "Mật khẩu phải có ít nhất 8 kí tự";
    }

    if (!confirmPassword.trim()){
      validationErrors.confirmPassword = "Nhập lại mật khẩu là bắt buộc";
    } else if(confirmPassword !== password){
        validationErrors.confirmPassword = "Mật khẩu không khớp";
    }

    setErrors(validationErrors);

    if (Object.keys(validationErrors).length === 0) {
      alert(`Form submitted:\nUsername: ${username}\nEmail: ${email}\nPassword: ${password}\nConfirm Password: ${confirmPassword}`);
    }
  }

  function handleChange(e){
    const {name,value} = e.target;
    setFormData({...formData, [name] : value});

    if (name === 'password') {
      setHasValuePassword(value !== '');
    } else if (name === 'confirm-password') {
        setHasValueConfirmPassword(value !== '');
    }
  }

    function togglePassword(){
      setShowPassword(!showPassword);
    }

    function toggleConfirmPassword(){
        setShowConfirmPassword(!showConfirmPassword);
    }

    return (
      <Box className="shadow-2xl px-5 py-7 w-full sm:w-8/12 lg:w-4/12 rounded mx-auto">
      <Typography component="h1" variant="h4" className="register-text text-center">Đăng ký</Typography>
      <Box component="form" validate="true" onSubmit={handleSubmit} className="mt-1 text-center flex flex-col">
          <TextField margin="normal" id="username" type="username" label="Tên người dùng" name="username" autoComplete="username" onChange={handleChange} autoFocus />
          {errors.username && <Box className="text-red-500 text-left text-sm">{errors.username}</Box>}
          <TextField margin="normal" id="email" type="email" label="Email" name="email" autoComplete="email" onChange={handleChange} autoFocus />
          {errors.email && <Box className="text-red-500 text-left text-sm">{errors.email}</Box>}
          <TextField margin="normal" name="password" label="Mật khẩu" type={showPassword ? 'text' : 'password'} id="password" onChange={handleChange} autoComplete="current-password"
              InputProps={{
                  endAdornment: hasValuePassword && (
                      <Button className="eye-button" onClick={togglePassword}>
                          {showPassword ? EyePassword : EyeClosePassword}
                      </Button>
                  )
              }}
          />
          {errors.password && <Box className="text-red-500 text-left text-sm">{errors.password}</Box>}
          <TextField margin="normal" name="confirm-password" label="Nhập lại mật khẩu" type={showConfirmPassword ? 'text' : 'password'} id="confirm-password" onChange={handleChange} autoComplete="current-password"
              InputProps={{
                  endAdornment: hasValueConfirmPassword && (
                      <Button className="eye-button" onClick={toggleConfirmPassword}>
                          {showConfirmPassword ? EyePassword : EyeClosePassword}
                      </Button>
                  )
              }}
          />
          {errors.confirmPassword && <Box className="text-red-500 text-left text-sm">{errors.confirmPassword}</Box>}
          <Button type="submit" variant="contained" className="submit-button ml-5">
              Đăng ký
          </Button>
          <Grid container className="mt-5 justify-center">
              <Grid item className="flex flex-row">
                  <Typography className="mr-0.5 px-1" variant="body2">Bạn đã có tài khoản? </Typography>
                  <Link className="text-blue-500 no-underline" href="#" variant="body2">Đăng nhập</Link>
              </Grid>
          </Grid>
      </Box>
  </Box>
    );
}

export default RegisterForm;