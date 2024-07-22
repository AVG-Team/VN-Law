const StorageKeys = {
    ACCESS_TOKEN: "ACCESS_TOKEN",
    REFRESH_TOKEN: "REFRESH_TOKEN",
    USER_NAME: "USER_NAME",
    USER_ROLE: "USER_ROLE",
};

const OAUTH2_REDIRECT_URI = import.meta.env.VITE_OAUTH2_REDIRECT_URI;

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:8000";
const GOOGLE_AUTH_URL = API_BASE_URL +"/auth"+ '/oauth2/authorize/google?redirect_uri=' + OAUTH2_REDIRECT_URI;

export { StorageKeys, API_BASE_URL, GOOGLE_AUTH_URL };
