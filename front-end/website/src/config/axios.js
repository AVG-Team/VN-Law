import axios from "axios";
import Cookies from "js-cookie";
import { StorageKeys } from "../common/constants/keys";

const baseURL = import.meta.env.VITE_API_BASE_URL || "http://localhost:8000";

const axiosClient = axios.create({
    baseURL: baseURL,
    headers: {
        "Content-Type": "application/json",
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
        console.error(error);
        Promise.reject(error);
    },
);

// Add a response interceptor
axiosClient.interceptors.response.use(
    function (response) {
        // Any status code that lie within the range of 2xx cause this function to trigger
        // Do something with response data
        return response.data || response.data.data;
    },
    function (error) {
        // Any status codes that falls outside the range of 2xx cause this function to trigger
        // Do something with response error
        console.log("Response error: ", error);

        if (error.response) {
            // Server trả về lỗi
            const status = error.response.status;
            const data = error.response.data;

            if (status === 401) {
                return Promise.reject({
                    status: 401,
                    message: data.message || "Tài khoản hoặc mật khẩu không đúng",
                });
            } else if (status === 400) {
                return Promise.reject({
                    status: 400,
                    message: data.message || "Tài khoản chưa được kích hoạt",
                });
            } else {
                // Xử lý các trường hợp lỗi khác nếu cần
                return Promise.reject(error);
            }
        } else {
            // Xử lý lỗi khi không nhận được phản hồi từ server
            console.log("Network error: ", error.message);
            return Promise.reject(error);
        }
    },
);

export default axiosClient;
