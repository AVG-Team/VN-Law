import { ChatActionTypes } from "../actions/chatAction";

const initialState = {
    messages: [],
    conversationId: null,
    isTyping: false,
    loading: false,
    error: null,
    suggestions: [],
    chatHistory: [],
    chatById: null,
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
            const { answer, context, urlRelate, executionTime, conversationId, question } = action.payload;
            const userMessage = {
                id: `${Date.now()}-user`,
                type: "user",
                context: question,
                timestamp: new Date().toISOString(),
            };

            let botContent = answer;
            if (context && typeof context === "string" && context.trim()) {
                botContent += "\n\n **Tài liệu tham khảo:**\n" + context;
            } else if (Array.isArray(context) && context.length > 0) {
                botContent += "\n\n **Tài liệu tham khảo:**\n";
                context.forEach((ctx, index) => {
                    botContent += `${index + 1}. ${ctx}\n`;
                });
            }

            if (urlRelate && urlRelate.length > 0) {
                botContent += "\n\n🔗 **Liên kết liên quan:**\n";
                urlRelate.forEach((url, index) => {
                    botContent += `${index + 1}. ${url}\n`;
                });
            }
            // if (executionTime) {
            //     botContent += `\n\n⏱️ *Thời gian xử lý: ${executionTime}*`;
            // }
            const botMessage = {
                id: Date.now() + "-bot",
                type: "bot",
                content: botContent,
                timestamp: new Date().toISOString(),
                context,
                urlRelate,
            };
            return {
                ...state,
                messages: [...state.messages, userMessage, botMessage],
                loading: false,
                conversationId: conversationId || state.conversationId,
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

        case ChatActionTypes.SET_CONVERSATION_ID:
            return {
                ...state,
                conversationId: action.payload,
            };

        case ChatActionTypes.CLEAR_CHAT:
            return {
                ...state,
                messages: [],
                isTyping: false,
                conversationId: null,
                suggestions: [],
            };

        case ChatActionTypes.GET_CHAT_HISTORY_REQUEST:
            return { ...state, loading: true, error: null };
        case ChatActionTypes.GET_CHAT_HISTORY_SUCCESS:
            return { ...state, loading: false, chatHistory: action.payload || [] };
        case ChatActionTypes.GET_CHAT_HISTORY_FAILURE:
            return { ...state, loading: false, error: action.payload };

        case ChatActionTypes.GET_CHAT_BY_ID_REQUEST:
            return { ...state, loading: true, error: null };
        case ChatActionTypes.GET_CHAT_BY_ID_SUCCESS:
            return {
                ...state,
                loading: false,
                messages: action.payload || [],
                chatById: action.payload,
            };
        case ChatActionTypes.GET_CHAT_BY_ID_FAILURE:
            return { ...state, loading: false, error: action.payload };

        case ChatActionTypes.CREATE_CONVERSATION_REQUEST:
            return { ...state, loading: true, error: null };
        case ChatActionTypes.CREATE_CONVERSATION_SUCCESS:
            return { ...state, loading: false, conversationId: action.payload };
        case ChatActionTypes.CREATE_CONVERSATION_FAILURE:
            return { ...state, loading: false, error: action.payload };

        case ChatActionTypes.DELETE_CONVERSATION_REQUEST:
            return { ...state, loading: true, error: null };
        case ChatActionTypes.DELETE_CONVERSATION_SUCCESS:
            return {
                ...state,
                loading: false,
                chatHistory: state.chatHistory.filter((chat) => chat.id !== action.payload),
                conversationId: state.conversationId === action.payload ? null : state.conversationId,
                messages: state.conversationId === action.payload ? [] : state.messages,
            };
        case ChatActionTypes.DELETE_CONVERSATION_FAILURE:
            return { ...state, loading: false, error: action.payload };

        default:
            return state;
    }
};

export default chatReducer;
