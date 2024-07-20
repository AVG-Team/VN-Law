import Cookies from "js-cookie";
import { useEffect } from "react";
import { jwtDecode } from "jwt-decode";
import axiosClient from "../axiosClient";
import { useNavigate } from "react-router-dom";
import { StorageKeys } from "../../common/constants/keys";
import { setToken } from "../../mock/auth";

export const authenticate = async (authenticateRequest) => {
    try {
        const url = "auth/authenticate";
        const response = await axiosClient.post(url, authenticateRequest);

        const { access_token, name, role } = response.data;
        setToken(access_token, name, role);

        return response;
    } catch (error) {
        console.error("Authenticate: ", error);
        throw error;
    }
};

export const verifyEmail = (verifyRequest) => {
    const url = "/auth/confirm-email";
    return axiosClient.post(url, verifyRequest);
};

export const register = (registerRequest) => {
    return axiosClient.post("/auth/register", registerRequest);
};

export const getCurrentUser = async (request) => {
    try {
        const url = "auth/get-current-user";
        const response = await axiosClient.post(url, request);

        console.log(response)

        const { name, role } = response.data;
        setToken(request.token, name, role);

        return response;
    } catch (error) {
        console.error("Authenticate: ", error);
        throw error;
    }
}

export const forgotPassword = (forgotPasswordRequest) => {
    const url = "/auth/forgot-password";
    return axiosClient.post(url, forgotPasswordRequest);
}

export const changePassword = (changePasswordRequest) => {
    const url = "/auth/change-password";
    return axiosClient.post(url, changePasswordRequest);
}