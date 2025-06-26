import { StorageKeys } from "../common/constants/keys";
import Cookies from "js-cookie";
import { jwtDecode } from "jwt-decode";

export const getUserInfo = () => {
    const name = localStorage.getItem(StorageKeys.USER_NAME) || "Guest";
    const role = localStorage.getItem(StorageKeys.USER_ROLE) || "GUEST";
    const token = Cookies.get(StorageKeys.ACCESS_TOKEN);
    const email = localStorage.getItem(StorageKeys.USER_EMAIL) || "";
    const keycloakId = localStorage.getItem(StorageKeys.USER_KEYCLOAK_ID) || "";
    const accessToken = localStorage.getItem(StorageKeys.ACCESS_TOKEN);
    const refreshToken = localStorage.getItem(StorageKeys.REFRESH_TOKEN);
    return { name, role, token, email, keycloakId, accessToken, refreshToken };
};

export const checkAuth = () => {
    return !!Cookies.get(StorageKeys.ACCESS_TOKEN);
};

export const checkAdmin = () => {
    return !!Cookies.get(StorageKeys.ACCESS_TOKEN) && localStorage.getItem(StorageKeys.USER_ROLE) === "ADMIN";
};

export const setToken = (response) => {
    const decodedToken = jwtDecode(response.access_token);
    const expirationTime = decodedToken.exp * 1000;

    Cookies.set(StorageKeys.ACCESS_TOKEN, response.access_token, { expires: new Date(expirationTime) });
    localStorage.setItem(StorageKeys.ACCESS_TOKEN, response.access_token);
    localStorage.setItem(StorageKeys.USER_NAME, response.name);
    localStorage.setItem(StorageKeys.USER_ROLE, response.role);
    localStorage.setItem(StorageKeys.USER_EMAIL, response.email);
    localStorage.setItem(StorageKeys.USER_KEYCLOAK_ID, response.keycloak_id);
    localStorage.setItem(StorageKeys.REFRESH_TOKEN, response.refresh_token);
};

export const clearToken = () => {
    Cookies.remove(StorageKeys.ACCESS_TOKEN);
    localStorage.removeItem(StorageKeys.ACCESS_TOKEN);
    localStorage.removeItem(StorageKeys.USER_NAME);
    localStorage.removeItem(StorageKeys.USER_ROLE);
    localStorage.removeItem(StorageKeys.USER_EMAIL);
    localStorage.removeItem(StorageKeys.USER_KEYCLOAK_ID);
    localStorage.removeItem(StorageKeys.REFRESH_TOKEN);
};
