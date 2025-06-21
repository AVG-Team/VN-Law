import { ChatActionTypes } from "../actions/chatAction";
import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { CHAT_API_BASE_URL } from "~/common/constants/keys";

const BASE_URL = CHAT_API_BASE_URL;

async function answerChatSaga(payload) {
    try {
        const response = await axios.post(`${BASE_URL}/get-answer`, {
            message,
        });
        return response.data;
    } catch (error) {
        throw new Error(error.response?.data?.message || "Lỗi kết nối đến server");
    }
}

function* fetchAnswerChatSaga(action) {
    try {
        const { message } = action.payload;

        // Thêm tin nhắn user vào state
        const userMessage = {
            id: `user_${Date.now()}`,
            type: "user",
            content: message,
            timestamp: new Date(),
            conversationId,
        };
        yield put({ type: ChatbotActionTypes.ADD_MESSAGE, payload: userMessage });

        // Bật typing indicator
        yield put({ type: ChatbotActionTypes.SET_TYPING, payload: true });

        // Gọi API
        const response = yield call(answerChatSaga, message);

        // Thêm tin nhắn bot vào state
        const botMessage = {
            id: response.messageId || `bot_${Date.now()}`,
            type: "bot",
            content: response.message,
            timestamp: new Date(),
            conversationId: response.conversationId,
            suggestions: response.suggestions || [],
        };

        yield put({ type: ChatbotActionTypes.SEND_MESSAGE_SUCCESS, payload: botMessage });
    } catch (error) {
        yield put({ type: ChatbotActionTypes.SEND_MESSAGE_FAILURE, payload: error.message });

        // Thêm tin nhắn lỗi
        const errorMessage = {
            id: `error_${Date.now()}`,
            type: "error",
            content: "Xin lỗi, đã có lỗi xảy ra. Vui lòng thử lại sau.",
            timestamp: new Date(),
        };
        yield put({ type: ChatbotActionTypes.ADD_MESSAGE, payload: errorMessage });
    } finally {
        // Tắt typing indicator
        yield put({ type: ChatbotActionTypes.SET_TYPING, payload: false });
    }
}

function getChatHistorySaga() {
    return axios.get(`${BASE_URL}/history`);
}

function* fetchGetChatHistorySaga() {
    try {
        const response = yield call(getChatHistorySaga);
        console.log("response", response.data);
        yield put({ type: ChatActionTypes.GET_CHAT_HISTORY_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: ChatActionTypes.GET_CHAT_HISTORY_FAILURE, payload: error.message });
    }
}

function getChatByIdSaga(id) {
    return axios.get(`${BASE_URL}/${id}`);
}

function* fetchGetChatByIdSaga(action) {
    try {
        const response = yield call(getChatByIdSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: ChatActionTypes.GET_CHAT_BY_ID_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: ChatActionTypes.GET_CHAT_BY_ID_FAILURE, payload: error.message });
    }
}

function getAllChatsSaga() {
    return axios.get(`${BASE_URL}/all`);
}

function* fetchGetAllChatsSaga() {
    try {
        const response = yield call(getAllChatsSaga);
        console.log("response", response.data);
        yield put({ type: ChatActionTypes.GET_ALL_CHATS_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: ChatActionTypes.GET_ALL_CHATS_FAILURE, payload: error.message });
    }
}

function getChatsByUserSaga(userId) {
    return axios.get(`${BASE_URL}/user/${userId}`);
}

function* fetchGetChatsByUserSaga(action) {
    try {
        const response = yield call(getChatsByUserSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: ChatActionTypes.GET_CHATS_BY_USER_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: ChatActionTypes.GET_CHATS_BY_USER_FAILURE, payload: error.message });
    }
}

// async function createConversationSaga() => {
//      try {
//             const response = await axios.post(`${BASE_URL}/chatbot/conversation`);
//             return response.data;
//         } catch (error) {
//             throw new Error(error.response?.data?.message || 'Không thể tạo cuộc trò chuyện mới');
//         }
// }

export default function* chatSaga() {
    yield takeLatest(ChatActionTypes.SEND_MESSAGE_REQUEST, fetchAnswerChatSaga);
    yield takeLatest(ChatActionTypes.GET_CHAT_HISTORY_REQUEST, fetchGetChatHistorySaga);
    yield takeLatest(ChatActionTypes.GET_CHAT_BY_ID_REQUEST, fetchGetChatByIdSaga);
    yield takeLatest(ChatActionTypes.GET_ALL_CHATS_REQUEST, fetchGetAllChatsSaga);
    yield takeLatest(ChatActionTypes.GET_CHATS_BY_USER_REQUEST, fetchGetChatsByUserSaga);
}
