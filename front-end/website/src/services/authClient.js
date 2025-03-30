import axios from "~/config/axios";
import { setToken } from "../mock/auth";

const urlAuth = "auth/api/auth/";
export const authenticate = async (authenticateRequest) => {
    try {
        const url = urlAuth + "authenticate";
        const response = await axios.post(url, authenticateRequest);

        const { access_token, name, role } = response.data;
        setToken(access_token, name, role);

        return response;
    } catch (error) {
        console.error("Authenticate: ", error);
        throw error;
    }
};

export const verifyEmail = (verifyRequest) => {
    const url = urlAuth + "confirm-email";
    return axios.post(url, verifyRequest);
};

export const register = (registerRequest) => {
    return axios.post(urlAuth + "register", registerRequest);
};

export const getCurrentUser = async (request) => {
    try {
        const url = urlAuth + "get-current-user";
        const response = await axios.post(url, request);
        const { name, role } = response.data;
        setToken(request.token, name, role);

        return response;
    } catch (error) {
        console.error("Authenticate: ", error);
        throw error;
    }
};

export const forgotPassword = (forgotPasswordRequest) => {
    const url = urlAuth + "forgot-password";
    return axios.post(url, forgotPasswordRequest);
};

export const changePassword = (changePasswordRequest) => {
    const url = urlAuth + "change-password";
    return axios.post(url, changePasswordRequest);
};
