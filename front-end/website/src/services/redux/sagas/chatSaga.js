import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { CHAT_API_BASE_URL, StorageKeys } from "~/common/constants/keys";
import { ChatActionTypes } from "../actions/chatAction";

const BASE_URL = CHAT_API_BASE_URL;

function answerChatSaga({ message, conversationId }) {
    return axios.post(
        `${BASE_URL}/api/chat/get-answer`,
        {
            question: message,
            conversation_id: conversationId || "",
        },
        {
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${localStorage.getItem(StorageKeys.ACCESS_TOKEN)}`,
            },
        }
    );
}

function* fetchAnswerChatSaga(action) {
    try {
        const { message, conversationId } = action.payload;
        const question = message.trim();

        // Bật typing indicator
        yield put({ type: ChatActionTypes.SET_TYPING, payload: true });

        // Gọi API
        const response = yield call(answerChatSaga, { message, conversationId });

        // Cập nhật conversation ID nếu có
        if (response.data.conversation_id !== conversationId) {
            yield put({
                type: ChatActionTypes.SET_CONVERSATION_ID,
                payload: response.data.conversation_id,
            });
        }

        // Dispatch success với dữ liệu từ API
        yield put({
            type: ChatActionTypes.SEND_MESSAGE_SUCCESS,
            payload: {
                answer: response.data.answer,
                context: response.data.context,
                urlRelate: response.data.url_relate,
                executionTime: response.data.execution_time,
                conversationId: response.data.conversation_id,
                question,
                message,
            },
        });
    } catch (error) {
        // Dispatch failure
        yield put({
            type: ChatActionTypes.SEND_MESSAGE_FAILURE,
            payload: error.response?.data?.message || error.message,
        });
    } finally {
        // Tắt typing indicator
        yield put({ type: ChatActionTypes.SET_TYPING, payload: false });
    }
}

function getChatHistorySaga() {
    return axios.get(`${BASE_URL}/api/chat/get-history`, {
        headers: {
            Authorization: `Bearer ${localStorage.getItem(StorageKeys.ACCESS_TOKEN)}`,
        },
    });
}

function* fetchGetChatHistorySaga() {
    try {
        const response = yield call(getChatHistorySaga);
        const conversations = response.data?.conversations || [];
        yield put({ type: ChatActionTypes.GET_CHAT_HISTORY_SUCCESS, payload: conversations });
    } catch (error) {
        yield put({
            type: ChatActionTypes.GET_CHAT_HISTORY_FAILURE,
            payload: error.response?.data?.message || error.message,
        });
    }
}

function getChatByIdSaga(id) {
    return axios.get(`${BASE_URL}/api/chat/get-messages?conversation_id=${id}`, {
        headers: {
            Authorization: `Bearer ${localStorage.getItem(StorageKeys.ACCESS_TOKEN)}`,
        },
    });
}

function* fetchGetChatByIdSaga(action) {
    try {
        const response = yield call(getChatByIdSaga, action.payload);
        const apiMessages = response.data?.messages || [];
        const messages = apiMessages.reduce((acc, msg) => {
            if (msg.question) {
                acc.push({
                    id: `${msg.message_id}-user`,
                    type: "user",
                    context: msg.question,
                    timestamp: new Date(msg.timestamp).toISOString(),
                });
            }
            acc.push({
                id: `${msg.message_id}-bot`,
                type: "bot",
                content: msg.content,
                timestamp: new Date(msg.timestamp).toISOString(),
                context: msg.context,
                conversation_id: msg.conversation_id,
            });
            return acc;
        }, []);
        yield put({ type: ChatActionTypes.GET_CHAT_BY_ID_SUCCESS, payload: messages });
    } catch (error) {
        console.error("Error fetching chat by id:", error);
        yield put({
            type: ChatActionTypes.GET_CHAT_BY_ID_FAILURE,
            payload: error.response?.data?.message || error.message,
        });
    }
}

function createConversationSaga() {
    return axios.post(`${BASE_URL}/api/chat/create-conversation`, {
        headers: {
            Authorization: `Bearer ${localStorage.getItem(StorageKeys.ACCESS_TOKEN)}`,
        },
    });
}

function* fetchCreateConversationSaga() {
    try {
        const response = yield call(createConversationSaga);
        yield put({
            type: ChatActionTypes.CREATE_CONVERSATION_SUCCESS,
            payload: response.data?.conversation_id || "",
        });
    } catch (error) {
        yield put({
            type: ChatActionTypes.CREATE_CONVERSATION_FAILURE,
            payload: error.response?.data?.message || error.message,
        });
    }
}

function deleteConversationSaga(id) {
    return axios.delete(`${BASE_URL}/api/chat/conversation/${id}`, {
        headers: {
            Authorization: `Bearer ${localStorage.getItem(StorageKeys.ACCESS_TOKEN)}`,
        },
    });
}

function* fetchDeleteConversationSaga(action) {
    try {
        yield call(deleteConversationSaga, action.payload);
        yield put({
            type: ChatActionTypes.DELETE_CONVERSATION_SUCCESS,
            payload: action.payload,
        });
    } catch (error) {
        yield put({
            type: ChatActionTypes.DELETE_CONVERSATION_FAILURE,
            payload: error.response?.data?.message || error.message,
        });
    }
}

export default function* chatSaga() {
    yield takeLatest(ChatActionTypes.SEND_MESSAGE_REQUEST, fetchAnswerChatSaga);
    yield takeLatest(ChatActionTypes.GET_CHAT_HISTORY_REQUEST, fetchGetChatHistorySaga);
    yield takeLatest(ChatActionTypes.GET_CHAT_BY_ID_REQUEST, fetchGetChatByIdSaga);
    yield takeLatest(ChatActionTypes.CREATE_CONVERSATION_REQUEST, fetchCreateConversationSaga);
    yield takeLatest(ChatActionTypes.DELETE_CONVERSATION_REQUEST, fetchDeleteConversationSaga);
}