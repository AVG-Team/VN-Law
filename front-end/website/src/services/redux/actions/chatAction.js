export const ChatActionTypes = {
    SEND_MESSAGE_REQUEST: "SEND_MESSAGE_REQUEST",
    SEND_MESSAGE_SUCCESS: "SEND_MESSAGE_SUCCESS",
    SEND_MESSAGE_FAILURE: "SEND_MESSAGE_FAILURE",

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

    CREATE_CONVERSATION_REQUEST: "CREATE_CONVERSATION_REQUEST",
    CREATE_CONVERSATION_SUCCESS: "CREATE_CONVERSATION_SUCCESS",
    CREATE_CONVERSATION_FAILURE: "CREATE_CONVERSATION_FAILURE",

    RATE_MESSAGE: "RATE_MESSAGE",
    CLEAR_CHAT: "CLEAR_CHAT",
    SET_TYPING: "SET_TYPING",
    ADD_MESSAGE: "ADD_MESSAGE",
};

export const sendMessageRequest = (message, conversationId) => ({
    type: ChatActionTypes.SEND_MESSAGE_REQUEST,
    payload: { message, conversationId },
});

export const sendMessageSuccess = (response) => ({
    type: ChatActionTypes.SEND_MESSAGE_SUCCESS,
    payload: response,
});

export const sendMessageFailure = (error) => ({
    type: ChatActionTypes.SEND_MESSAGE_FAILURE,
    payload: error,
});

export const getChatHistoryRequest = () => ({
    type: ChatActionTypes.GET_CHAT_HISTORY_REQUEST,
});

export const getChatHistorySuccess = (history) => ({
    type: ChatActionTypes.GET_CHAT_HISTORY_SUCCESS,
    payload: history,
});

export const getChatHistoryFailure = (error) => ({
    type: ChatActionTypes.GET_CHAT_HISTORY_FAILURE,
    payload: error,
});

export const getChatByIdRequest = (id) => ({
    type: ChatActionTypes.GET_CHAT_BY_ID_REQUEST,
    payload: id,
});

export const getChatByIdSuccess = (chat) => ({
    type: ChatActionTypes.GET_CHAT_BY_ID_SUCCESS,
    payload: chat,
});

export const getChatByIdFailure = (error) => ({
    type: ChatActionTypes.GET_CHAT_BY_ID_FAILURE,
    payload: error,
});

export const createConversationRequest = (conversation) => ({
    type: ChatActionTypes.CREATE_CONVERSATION_REQUEST,
    payload: conversation,
});

export const getAllChatsRequest = () => ({
    type: ChatActionTypes.GET_ALL_CHATS_REQUEST,
});

export const getChatsByUserRequest = (userId) => ({
    type: ChatActionTypes.GET_CHATS_BY_USER_REQUEST,
    payload: userId,
});

export const rateMessage = (messageId, rating) => ({
    type: ChatbotActionTypes.RATE_MESSAGE,
    payload: { messageId, rating },
});

export const clearChat = () => ({
    type: ChatbotActionTypes.CLEAR_CHAT,
});

export const setTyping = (isTyping) => ({
    type: ChatbotActionTypes.SET_TYPING,
    payload: isTyping,
});

export const addMessage = (message) => ({
    type: ChatbotActionTypes.ADD_MESSAGE,
    payload: message,
});
