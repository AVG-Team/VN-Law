import axios from "axios";
import { StorageKeys } from "~/common/constants/keys";
import Cookies from "js-cookie";
import { jwtDecode } from "jwt-decode";

const BASE_URL = "http://localhost:9006";

const getAuthHeader = () => {
    const token = localStorage.getItem(StorageKeys.ACCESS_TOKEN);
    return {
        Authorization: `Bearer ${token}`,
    };
};

const api = axios.create({
    baseURL: BASE_URL,
    headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,PATCH,OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
    },
    withCredentials: true,
});

// Add request interceptor to add auth token
api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem(StorageKeys.ACCESS_TOKEN);
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    },
);

// Add response interceptor to handle token expiration
api.interceptors.response.use(
    (response) => response,
    async (error) => {
        if (error.response?.status === 401) {
            // Handle token expiration
            localStorage.removeItem(StorageKeys.ACCESS_TOKEN);
            window.location.href = "/login";
        }
        return Promise.reject(error);
    },
);

const forumApi = {
    // Posts
    getPosts: async (filter = "all", page = 1, pageSize = 10) => {
        const response = await api.get("/api/posts", {
            params: { filter, page, page_size: pageSize },
        });
        return response.data;
    },

    createPost: async (postData) => {
        const response = await api.post("/api/posts", postData);
        return response.data;
    },

    getPost: async (postId) => {
        const response = await api.get(`/api/posts/${postId}`);
        return response.data;
    },

    updatePost: async (postId, postData) => {
        const response = await api.patch(`/api/posts/${postId}`, postData);
        return response.data;
    },

    deletePost: async (postId) => {
        const response = await api.delete(`/api/posts/${postId}`);
        return response.data;
    },

    // Comments
    createComment: async (postId, commentData) => {
        const response = await api.post(`/api/posts/${postId}/comments`, commentData);
        return response.data;
    },

    updateComment: async (commentId, commentData) => {
        const response = await api.patch(`/api/comments/${commentId}`, commentData);
        return response.data;
    },

    deleteComment: async (commentId) => {
        const response = await api.delete(`/api/comments/${commentId}`);
        return response.data;
    },

    // Likes & Stars
    likePost: async (postId) => {
        const response = await api.post(`/api/posts/${postId}/like`);
        return response.data;
    },

    starPost: async (postId) => {
        const response = await api.post(`/api/posts/${postId}/star`);
        return response.data;
    },

    // User specific
    getLikedPosts: async () => {
        const response = await api.get("/api/users/me/likes");
        return response.data;
    },

    getStarredPosts: async () => {
        const response = await api.get("/api/users/me/stars");
        return response.data;
    },

    // Notifications
    getNotifications: async () => {
        const response = await api.get("/api/notifications");
        return response.data;
    },

    // Admin actions
    pinPost: async (postId) => {
        const response = await api.post(`/api/posts/${postId}/pin`);
        return response.data;
    },

    unpinPost: async (postId) => {
        const response = await api.post(`/api/posts/${postId}/unpin`);
        return response.data;
    },

    // Search
    searchPosts: async (query) => {
        const response = await api.get("/api/posts/search", {
            params: { query },
        });
        return response.data;
    },
};

export default forumApi;
