import axios from "axios";
import Cookies from "js-cookie";
import { useEffect} from 'react'
import { jwtDecode } from "jwt-decode";
import { useNavigate } from 'react-router-dom'
import { StorageKeys, API_BASE_URL } from "../../common/constants/keys";

const request = axios.create({
    baseURL: API_BASE_URL,
    headers: {
        "Content-Type": "application/json",
    },
});

request.interceptors.request.use(
    (config) => {
        const token = Cookies.get(StorageKeys.ACCESS_TOKEN);
        if (token) {
            config.headers["Authorization"] = "Bearer " + token;
        }
        return config;
    },
    (error) => {
        Promise.reject(error);
    },
);


export const authenticate = async (authenticateRequest) => {
    try {
        const response = await request.post("/auth/authenticate", authenticateRequest);

        const { access_token } = response.data;
        const decodedToken = jwtDecode(access_token);
        const expirationTime = decodedToken.exp * 1000;

        Cookies.set(StorageKeys.ACCESS_TOKEN, access_token, { expires: new Date(expirationTime) });

        return response;
    } catch (error) {
        console.log("Authenticate: ", error);
        throw error;
    }
};

export const register = (registerRequest) => {
    return request.post("/auth/register",registerRequest);
};

export const useCheckTokenExpiration = () => {
    const navigate = useNavigate();

    useEffect(() => {
        const handleTokenExpiration = () => {
            Cookies.remove(StorageKeys.ACCESS_TOKEN);
        };

        const checkTokenExpiration = () => {
            const accessToken = Cookies.get(StorageKeys.ACCESS_TOKEN);
            if (accessToken) {
                const decodedToken = jwtDecode(accessToken);
                const expirationToken = decodedToken.exp * 1000;
                const currentTime = new Date().getTime();

                if (expirationToken <= currentTime) {
                    handleTokenExpiration();
                }
            }
        };
        const interval = setInterval(checkTokenExpiration, 60000);
        return () => clearInterval(interval);
    }, [navigate]);
};

export const forgotPassword = async (email) =>{
    try{
        const response = await request.post("/auth/forgot-password",{email});
        return response.data;
    }catch(err){
        console.log("Forgot password error: ", err);
        throw err;
    }
}

export const verifyTokenResetPassword = async (email, resetPasswordToken) => {
    try{
        const response = await request.post("/auth/verify-token",{
            email, 
            resetPasswordToken
        });
        return response.data;
    }catch(err){
        console.log("Verify error: ", err);
        throw err;
    }
}

export const resetPassword = async (email, newPassword, resetPasswordToken) => {
    try{
        const response = await request.post("/auth/set-new-password",{
            email,
            newPassword,
            resetPasswordToken
        });
        return response.data;
    }catch(err){
        console.log("ResetPassword error: ", err);
        throw err;
    }
}