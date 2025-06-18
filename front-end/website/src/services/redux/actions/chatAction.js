export const ChatActionTypes = {
    ANSWER_CHAT_REQUEST: "ANSWER_CHAT_REQUEST",
    ANSWER_CHAT_SUCCESS: "ANSWER_CHAT_SUCCESS",
    ANSWER_CHAT_FAILURE: "ANSWER_CHAT_FAILURE",

    GET_CHAT_HISTORY_REQUEST: "GET_CHAT_HISTORY_REQUEST",
    GET_CHAT_HISTORY_SUCCESS: "GET_CHAT_HISTORY_SUCCESS",
    GET_CHAT_HISTORY_FAILURE: "GET_CHAT_HISTORY_FAILURE",

    GET_CHAT_BY_ID_REQUEST: "GET_CHAT_BY_ID_REQUEST",
    GET_CHAT_BY_ID_SUCCESS: "GET_CHAT_BY_ID_SUCCESS",
    GET_CHAT_BY_ID_FAILURE: "GET_CHAT_BY_ID_FAILURE",

    GET_ALL_CHATS_REQUEST: "GET_ALL_CHATS_REQUEST",
    GET_ALL_CHATS_SUCCESS: "GET_ALL_CHATS_SUCCESS",
    GET_ALL_CHATS_FAILURE: "GET_ALL_CHATS_FAILURE",

    GET_CHATS_BY_USER_REQUEST: "GET_CHATS_BY_USER_REQUEST",
    GET_CHATS_BY_USER_SUCCESS: "GET_CHATS_BY_USER_SUCCESS",
    GET_CHATS_BY_USER_FAILURE: "GET_CHATS_BY_USER_FAILURE",
};

export const answerChatRequest = (question) => ({
    type: ChatActionTypes.ANSWER_CHAT_REQUEST,
    payload: question,
});

export const getChatHistoryRequest = () => ({
    type: ChatActionTypes.GET_CHAT_HISTORY_REQUEST,
});

export const getChatByIdRequest = (id) => ({
    type: ChatActionTypes.GET_CHAT_BY_ID_REQUEST,
    payload: id,
});

export const getAllChatsRequest = () => ({
    type: ChatActionTypes.GET_ALL_CHATS_REQUEST,
});

export const getChatsByUserRequest = (userId) => ({
    type: ChatActionTypes.GET_CHATS_BY_USER_REQUEST,
    payload: userId,
});
