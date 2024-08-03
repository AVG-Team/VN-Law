import axiosClient from "../axiosClient";

const urlChat = "http://localhost:9004/api/";

export const getConversations = () => {
    const url = urlChat + "get-conversations";
    return axiosClient.get(url);
};

export const getMessages = (conversationId) => {
    const url = urlChat + "get-messages/" + conversationId;
    return axiosClient.get(url);
};

export const deleteConversation = (id) => {
    const url = urlChat + "delete-conversation/" + id;
    return axiosClient.delete(url);
};