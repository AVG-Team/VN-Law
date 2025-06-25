import { ChatActionTypes } from "../actions/chatAction";
import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { CHAT_API_BASE_URL, StorageKeys } from "~/common/constants/keys";

const BASE_URL = CHAT_API_BASE_URL;

async function answerChatSaga(question) {
    try {
        const token = localStorage.getItem(StorageKeys.ACCESS_TOKEN);

        if (!token) {
            throw new Error("Bạn cần đăng nhập để sử dụng tính năng này");
        }

        const response = await fetch(`${BASE_URL}/api/chat/get-answer`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${token}`,
            },
            body: JSON.stringify({
                question: question,
                conversation_id: conversationId,
            }),
        });

        if (!response.ok) {
            if (response.status === 401) {
                throw new Error("Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
            }
            if (response.status === 400) {
                throw new Error("Câu hỏi không hợp lệ. Vui lòng thử lại.");
            }
            throw new Error("Có lỗi xảy ra khi kết nối đến server");
        }

        const data = await response.json();

        if (data.status_code !== 200) {
            throw new Error(data.message || "Có lỗi xảy ra");
        }

        return data.data;
    } catch (error) {
        console.error("Chat API Error:", error);
        throw error;
    }
}

function* fetchAnswerChatSaga(action) {
    try {
        const { question, conversationId } = action.payload;

        // Bật typing indicator
        yield put({ type: ChatActionTypes.SET_TYPING, payload: true });

        // Gọi API
        const response = yield call(sendChatMessageApi, question);

        // Cập nhật conversation ID nếu có
        if (response.conversation_id !== conversationId) {
            yield put({
                type: ChatActionTypes.SET_CONVERSATION_ID,
                payload: response.conversation_id,
            });
        }

        // Dispatch success với dữ liệu từ API
        yield put({
            type: ChatActionTypes.SEND_MESSAGE_SUCCESS,
            payload: {
                answer: response.answer,
                context: response.context,
                urlRelate: response.url_relate,
                executionTime: response.execution_time,
                conversationId: response.conversation_id,
                question: question,
            },
        });
    } catch (error) {
        // Dispatch failure
        yield put({
            type: ChatActionTypes.SEND_MESSAGE_FAILURE,
            payload: error.message,
        });
    } finally {
        // Tắt typing indicator
        yield put({ type: ChatActionTypes.SET_TYPING, payload: false });
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
