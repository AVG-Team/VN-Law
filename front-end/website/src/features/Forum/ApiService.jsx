import axios from "axios";
import { StorageKeys } from "~/common/constants/keys";
import Cookies from "js-cookie";
import { jwtDecode } from "jwt-decode";

const BASE_URL = "http://https://c5fa-101-99-32-135.ngrok-free.app";
var token_tmp =
    "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI4UGJoTHZURGRTZXBpVmxQVFZnN3JlcWVHQ0dsUWlYOEJzT1VpU0NkWVhZIn0.eyJleHAiOjE3NTAyMTYxNDcsImlhdCI6MTc1MDIxMjU0NywianRpIjoiNjg1MDZmNmUtZDkyOS00NWU5LWIxMzUtNzI2MTMzOWJiNTgxIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrOjgwODAvcmVhbG1zL3ZubGF3IiwiYXVkIjpbImZsYXNrLXNlcnZpY2UtY2xpZW50IiwibGF3LXNlcnZpY2UiLCJhY2NvdW50Il0sInN1YiI6ImRmNjk1ZDM0LWExYWYtNGQ0OC1iOTZkLTdjYWZlNDM3YWZmMyIsInR5cCI6IkJlYXJlciIsImF6cCI6Im1vYmlsZS1hcHAtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6IjI4ZGQ5MWY5LTA3YWQtNDdjMy05YTY2LTllYzllOWMxYmNjNCIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy12bmxhdyIsIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iLCJ1c2VyLVZOLUxhdyIsImFkbWluLVZOLUxhdyJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImZsYXNrLXNlcnZpY2UtY2xpZW50Ijp7InJvbGVzIjpbIkZsYXNrIHJlYWQiLCJmbGFzayB3cml0ZSJdfSwibGF3LXNlcnZpY2UiOnsicm9sZXMiOlsiTEFXIFJlYWQiXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfSwibW9iaWxlLWFwcC1jbGllbnQiOnsicm9sZXMiOlsiQVVUSF9VU0VSIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiMjhkZDkxZjktMDdhZC00N2MzLTlhNjYtOWVjOWU5YzFiY2M0IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5hbWUiOiJOZ3V5ZW4gIER1bmciLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJkdW5nQG50ZC1kZXYudGVjaCIsImdpdmVuX25hbWUiOiJOZ3V5ZW4gIiwiZmFtaWx5X25hbWUiOiJEdW5nIiwiZW1haWwiOiJkdW5nQG50ZC1kZXYudGVjaCJ9.VFg8uE0jSgM_KQsrC0i3A47yEHl3b-yraqKZZay20thTjdzocRvCmS5zNfHOj9JdNidb6JjpW5d0Ijmbsy0LdEe1zapQXyWtcp5HptaIIn9nWIYqAPhawdmFTuG7lSzT_I3pFMEz9FeQL7G05GLbPntfvjjYSFKwvk9W3RNmLbIjCUV7t_-xfed4Bhg9rkr2UBqeJxZuEsbxLasPrawHg8mqBJ-LOdPzANAyaCdC1otoUaE0EY_6pnYFmAdpf5OQ-RcKbgucrHnS7QAJuNrB3MxlkgGkb7jNDaQxC7eq4JhCrb71foy8CJWrSTgFoKnvSH0fwUSmd__BWwPyewf4Eg";
localStorage.setItem(StorageKeys.ACCESS_TOKEN, token_tmp);

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
