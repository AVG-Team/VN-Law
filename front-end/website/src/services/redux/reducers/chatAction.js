import { ChatActionTypes } from "../actions/chatAction";

const initialState = {
    chatHistory: [],
    chatByUser: [],
    answerChat: null, // Kết quả trả lời của chat
    chatById: null, // Chi tiết một chat
    allChats: [], // Danh sách tất cả các chat
    loading: false, // Trạng thái đang tải
};

const chatReducer = (state = initialState, action) => {
    switch (action.type) {
        // Xử lý khi trả lời chat
        case ChatActionTypes.ANSWER_CHAT_REQUEST:
            return { ...state, loading: true, answerChat: null };
        case ChatActionTypes.ANSWER_CHAT_SUCCESS:
            return { ...state, loading: false, answerChat: action.payload };
        case ChatActionTypes.ANSWER_CHAT_FAILURE:
            return { ...state, loading: false, error: action.payload };

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
