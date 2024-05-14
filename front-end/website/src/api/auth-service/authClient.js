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
                const currentTime = Date.now().getTime();

                if (expirationToken <= currentTime) {
                    handleTokenExpiration();
                }
            }
        };
    });
};