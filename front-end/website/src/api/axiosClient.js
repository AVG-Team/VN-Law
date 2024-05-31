import axios from "axios";
import Cookies from "js-cookie";
import { StorageKeys } from "../common/constants/keys";

const axiosClient = axios.create({
    baseURL: "http://localhost:9000",
    headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer YOUR_JWT_TOKEN`,
    },
});

// Interceptors
// Add a request interceptor
axiosClient.interceptors.request.use(
    (config) => {
        const token = Cookies.get(StorageKeys.ACCESS_TOKEN);
        if (token) {
            config.headers["Authorization"] = "Bearer " + token;
        }
        return config;
    },
    (error) => {
        console.log(error);
        Promise.reject(error);
    },
);

// Add a response interceptor
axiosClient.interceptors.response.use(
    function (response) {
        // Any status code that lie within the range of 2xx cause this function to trigger
        // Do something with response data
        return response.data.data || response.data;
    },
    function (error) {
        // Any status codes that falls outside the range of 2xx cause this function to trigger
        // Do something with response error
        console.log(error);
        return Promise.reject(new Error(error));
    },
);

export default axiosClient;
