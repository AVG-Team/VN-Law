import { ChatActionTypes } from "../actions/chatAction";

const initialState = {
    messages: [],
    conversationId: null,
    isTyping: false,
    loading: false,
    error: null,
    suggestions: [],
};

const chatReducer = (state = initialState, action) => {
    switch (action.type) {
        // Xử lý khi trả lời chat
        case ChatActionTypes.SEND_MESSAGE_REQUEST:
            return {
                ...state,
                loading: true,
                error: null,
            };
        case ChatActionTypes.SEND_MESSAGE_SUCCESS:
            return {
                ...state,
                messages: [...state.messages, action.payload],
                loading: false,
                suggestions: action.payload.suggestions || [],
            };
        case ChatActionTypes.SEND_MESSAGE_FAILURE:
            return {
                ...state,
                loading: false,
                error: action.payload,
            };

        case ChatActionTypes.ADD_MESSAGE:
            return {
                ...state,
                messages: [...state.messages, action.payload],
            };

        case ChatActionTypes.SET_TYPING:
            return {
                ...state,
                isTyping: action.payload,
            };

        case ChatActionTypes.CLEAR_CHAT:
            return {
                ...state,
                messages: [
                    {
                        id: "welcome_new",
                        type: "bot",
                        content: "🗑️ Cuộc trò chuyện đã được xóa.\n\n**Tôi có thể giúp gì khác cho bạn?**",
                        timestamp: new Date(),
                    },
                ],
                conversationId: null,
                suggestions: [],
            };

        // Xử lý khi lấy lịch sử chat
        case ChatActionTypes.GET_CHAT_HISTORY_REQUEST:
            return { ...state, loading: true, chatHistory: [] };
        case ChatActionTypes.GET_CHAT_HISTORY_SUCCESS:
            return { ...state, loading: false, chatHistory: action.payload };
        case ChatActionTypes.GET_CHAT_HISTORY_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy chat theo ID
        case ChatActionTypes.GET_CHAT_BY_ID_REQUEST:
            return { ...state, loading: true, chatById: null };
        case ChatActionTypes.GET_CHAT_BY_ID_SUCCESS:
            return { ...state, loading: false, chatById: action.payload };
        case ChatActionTypes.GET_CHAT_BY_ID_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy tất cả các chat
        case ChatActionTypes.GET_ALL_CHATS_REQUEST:
            return { ...state, loading: true, allChats: [] };
        case ChatActionTypes.GET_ALL_CHATS_SUCCESS:
            return { ...state, loading: false, allChats: action.payload };
        case ChatActionTypes.GET_ALL_CHATS_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy các chat theo người dùng
        case ChatActionTypes.GET_CHATS_BY_USER_REQUEST:
            return { ...state, loading: true, chatByUser: [] };
        case ChatActionTypes.GET_CHATS_BY_USER_SUCCESS:
            return { ...state, loading: false, chatByUser: action.payload };
        case ChatActionTypes.GET_CHATS_BY_USER_FAILURE:
            return { ...state, loading: false, error: action.payload };

        default:
            return state;
    }
};

export default chatReducer;
