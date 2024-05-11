// import { ACCESS_TOKEN, API_BASE_URL, REFRESH_TOKEN } from "../../common/constants";
// import axios from 'axios';

// const request = axios.create({
//     baseURL: API_BASE_URL,
//     headers: {
//         'Content-Type': 'application/json'
//     }
// });

// request.interceptors.request.use(
//     config => {
//         const token = localStorage.getItem(ACCESS_TOKEN);
//         if (token) {
//             config.headers['Authorization'] = 'Bearer ' + token;
//         }
//         return config;
//     },
//     error => {
//         Promise.reject(error);
//     }
// );

// // request.interceptors.response.use(
// //     (response) => response,
// //     async (error) => {
// //       const originalRequest = error.config;
// //       if (error.response.status === 401 && !originalRequest._retry) {
// //         originalRequest._retry = true;
// //         try {
// //           const refreshToken = localStorage.getItem(REFRESH_TOKEN);
// //           const response = await axios.post(`${API_BASE_URL}/auth/refresh-token`, { refreshToken });
// //           const { access_token } = response.data;
// //           localStorage.setItem(ACCESS_TOKEN, access_token);
// //           request.defaults.headers.common['Authorization'] = `Bearer ${access_token}`;
// //           return request(originalRequest);
// //         } catch (error) {
// //           // Xử lý lỗi khi refresh_token không hợp lệ
// //           console.error('Refresh token error:', error);
// //           localStorage.removeItem(ACCESS_TOKEN);
// //           localStorage.removeItem(REFRESH_TOKEN);
// //           // Xử lý đăng xuất hoặc chuyển hướng về trang đăng nhập
// //           return Promise.reject(error);
// //         }
// //       }
// //       return Promise.reject(error);
// //     }
// //   );

// export const authenticate = (authenticateRequest) => {
//     return request.post("/auth/authenticate", authenticateRequest);
// }

// export const register = (registerRequest) => {
//     return request.post("/auth/register", registerRequest);
// }

// // export const entryPoint = (entryPointRequest) => {
// //     if(!localStorage.getItem(ACCESS_TOKEN)){
// //         return PromiseRejectionEvent.reject("No access token set");
// //     }
// //     const response = request.get("/demo-controller",entryPointRequest);
// //     console.log(response);
// //     return response;
// // }

import axios from 'axios';
import Cookies from "js-cookie";
import { StorageKeys, API_BASE_URL } from '../../common/constants/keys'

const request = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
});

request.interceptors.request.use(
  config => {
    const token = Cookies.get(StorageKeys.ACCESS_TOKEN);
    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token;
    }
    return config;
  },
  error => {
    Promise.reject(error);
  }
);

// request.interceptors.response.use(
//     (response) => response,
//     async (error) => {
//       const originalRequest = error.config;
//       if (error.response.status === 401 && !originalRequest._retry) {
//         originalRequest._retry = true;
//         try {
//           const refreshToken = localStorage.getItem(REFRESH_TOKEN);
//           const response = await axios.post(`${API_BASE_URL}/auth/refresh-token`, { refreshToken });
//           const { access_token } = response.data;
//           localStorage.setItem(ACCESS_TOKEN, access_token);
//           request.defaults.headers.common['Authorization'] = `Bearer ${access_token}`;
//           return request(originalRequest);
//         } catch (error) {
//           // Xử lý lỗi khi refresh_token không hợp lệ
//           console.error('Refresh token error:', error);
//           localStorage.removeItem(ACCESS_TOKEN);
//           localStorage.removeItem(REFRESH_TOKEN);
//           // Xử lý đăng xuất hoặc chuyển hướng về trang đăng nhập
//           return Promise.reject(error);
//         }
//       }
//       return Promise.reject(error);
//     }
//   );

export const authenticate = (authenticateRequest) => {
  return request.post("/auth/authenticate", authenticateRequest);
};

export const register = (registerRequest) => {
  return request.post("/auth/register", registerRequest);
};