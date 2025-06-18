import axios from 'axios';
import { StorageKeys } from "~/common/constants/keys";
import Cookies from "js-cookie";
import { jwtDecode } from "jwt-decode";

const BASE_URL = 'http://localhost:9006';
var token_tmp = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI4UGJoTHZURGRTZXBpVmxQVFZnN3JlcWVHQ0dsUWlYOEJzT1VpU0NkWVhZIn0.eyJleHAiOjE3NTAyMDM3MzksImlhdCI6MTc1MDIwMDEzOSwianRpIjoiZDc5YTY1NWYtNWQzZi00ZGM3LTljOWItNTM0N2MxNWE2YTA0IiwiaXNzIjoiaHR0cDovL2tleWNsb2FrOjgwODAvcmVhbG1zL3ZubGF3IiwiYXVkIjpbImZsYXNrLXNlcnZpY2UtY2xpZW50IiwibGF3LXNlcnZpY2UiLCJhY2NvdW50Il0sInN1YiI6ImRmNjk1ZDM0LWExYWYtNGQ0OC1iOTZkLTdjYWZlNDM3YWZmMyIsInR5cCI6IkJlYXJlciIsImF6cCI6Im1vYmlsZS1hcHAtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6ImVhYjM2M2Y0LTI1ZDUtNDZmNS1hZDYyLWQ2YTczZTY3MGE2YiIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy12bmxhdyIsIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iLCJ1c2VyLVZOLUxhdyIsImFkbWluLVZOLUxhdyJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImZsYXNrLXNlcnZpY2UtY2xpZW50Ijp7InJvbGVzIjpbIkZsYXNrIHJlYWQiLCJmbGFzayB3cml0ZSJdfSwibGF3LXNlcnZpY2UiOnsicm9sZXMiOlsiTEFXIFJlYWQiXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfSwibW9iaWxlLWFwcC1jbGllbnQiOnsicm9sZXMiOlsiQVVUSF9VU0VSIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiZWFiMzYzZjQtMjVkNS00NmY1LWFkNjItZDZhNzNlNjcwYTZiIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5hbWUiOiJOZ3V5ZW4gIER1bmciLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJkdW5nQG50ZC1kZXYudGVjaCIsImdpdmVuX25hbWUiOiJOZ3V5ZW4gIiwiZmFtaWx5X25hbWUiOiJEdW5nIiwiZW1haWwiOiJkdW5nQG50ZC1kZXYudGVjaCJ9.SZyaXespPkkDE0HRAk5fq17BDEnoBOi1bhXqSk8U0yJdekIm4fWEfPsO9oHLmDyhhodBvpp0DhuEY4_ZGyGalO7qyI4Q4vpHgamK1DyjZJCxGEU06JMCm3P8atI9SzLwuHdCoTisU-WRYDAvExtPYpqe5mFaLtTi3o_nNV3rTBhAOFiW2t4wbUIJZwe7sGd-jIfh7NmDMdPWW_VCnT2jYqMRXVvknAHVG0vdHfSH824rhnRalLXm6we5k2nIAohaRRvnMuqVUa7_p-JbNLsr4e6yj40JeFd_J3tNaocGaWutDpsK-8ITC3p0PSIl4uXlpLATMVgakv9ukyy03oCAZw";
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
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,PATCH,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  },
  withCredentials: true
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
  }
);

// Add response interceptor to handle token expiration
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      // Handle token expiration
      localStorage.removeItem(StorageKeys.ACCESS_TOKEN);
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

const forumApi = {
  // Posts
  getPosts: async (filter = 'all', page = 1, pageSize = 10) => {
    const response = await api.get('/api/posts', {
      params: { filter, page, page_size: pageSize },
    });
    return response.data;
  },

  createPost: async (postData) => {
    const response = await api.post('/api/posts', postData);
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
    const response = await api.get('/api/users/me/likes');
    return response.data;
  },

  getStarredPosts: async () => {
    const response = await api.get('/api/users/me/stars');
    return response.data;
  },

  // Notifications
  getNotifications: async () => {
    const response = await api.get('/api/notifications');
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
    const response = await api.get('/api/posts/search', {
      params: { query },
    });
    return response.data;
  },
};

export default forumApi;