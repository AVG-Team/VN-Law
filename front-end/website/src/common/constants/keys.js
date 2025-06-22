const StorageKeys = {
    ACCESS_TOKEN: "ACCESS_TOKEN",
    REFRESH_TOKEN: "REFRESH_TOKEN",
    USER_NAME: "USER_NAME",
    USER_ROLE: "USER_ROLE",
    USER_EMAIL: "USER_EMAIL",
    USER_KEYCLOAK_ID: "USER_KEYCLOAK_ID",
};

const OAUTH2_REDIRECT_URI = import.meta.env.VITE_OAUTH2_REDIRECT_URI;

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:8000";
const GOOGLE_AUTH_URL = API_BASE_URL + "/auth" + "/oauth2/authorize/google?redirect_uri=" + OAUTH2_REDIRECT_URI;

const LAW_API_BASE_URL =
    import.meta.env.VITE_LAWYER_API_BASE_URL || "https://7249-2a09-bac5-d468-1d05-00-2e4-31.ngrok-free.app/law/api";
const CHAT_API_BASE_URL = import.meta.env.VITE_CHAT_API_BASE_URL || "http://0.0.0.0:9006/api/chat";

export { StorageKeys, API_BASE_URL, GOOGLE_AUTH_URL, LAW_API_BASE_URL, CHAT_API_BASE_URL };
