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

    CREATE_CONVERSATION_REQUEST: "CREATE_CONVERSATION_REQUEST",
    CREATE_CONVERSATION_SUCCESS: "CREATE_CONVERSATION_SUCCESS",
    CREATE_CONVERSATION_FAILURE: "CREATE_CONVERSATION_FAILURE",

    DELETE_CONVERSATION_REQUEST: "DELETE_CONVERSATION_REQUEST",
    DELETE_CONVERSATION_SUCCESS: "DELETE_CONVERSATION_SUCCESS",
    DELETE_CONVERSATION_FAILURE: "DELETE_CONVERSATION_FAILURE",

    RATE_MESSAGE: "RATE_MESSAGE",
    CLEAR_CHAT: "CLEAR_CHAT",
    SET_TYPING: "SET_TYPING",
    ADD_MESSAGE: "ADD_MESSAGE",
    SET_CONVERSATION_ID: "SET_CONVERSATION_ID",
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

export const createConversationRequest = () => ({
    type: ChatActionTypes.CREATE_CONVERSATION_REQUEST,
});

export const createConversationSuccess = (conversationId) => ({
    type: ChatActionTypes.CREATE_CONVERSATION_SUCCESS,
    payload: conversationId,
});

export const createConversationFailure = (error) => ({
    type: ChatActionTypes.CREATE_CONVERSATION_FAILURE,
    payload: error,
});

export const deleteConversationRequest = (id) => ({
    type: ChatActionTypes.DELETE_CONVERSATION_REQUEST,
    payload: id,
});

export const deleteConversationSuccess = (id) => ({
    type: ChatActionTypes.DELETE_CONVERSATION_SUCCESS,
    payload: id,
});

export const deleteConversationFailure = (error) => ({
    type: ChatActionTypes.DELETE_CONVERSATION_FAILURE,
    payload: error,
});

export const rateMessage = (messageId, rating) => ({
    type: ChatActionTypes.RATE_MESSAGE,
    payload: { messageId, rating },
});

export const clearChat = () => ({
    type: ChatActionTypes.CLEAR_CHAT,
});

export const setTyping = (isTyping) => ({
    type: ChatActionTypes.SET_TYPING,
    payload: isTyping,
});

export const addMessage = (message) => ({
    type: ChatActionTypes.ADD_MESSAGE,
    payload: message,
});

export const setConversationId = (conversationId) => ({
    type: ChatActionTypes.SET_CONVERSATION_ID,
    payload: conversationId,
});