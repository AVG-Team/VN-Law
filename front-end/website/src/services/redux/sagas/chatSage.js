import { ChatActionTypes } from "../actions/chatAction";
import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { LAW_API_BASE_URL } from "~/common/constants/keys";

const BASE_URL = LAW_API_BASE_URL + "/chat";

function answerChatSaga(payload) {
    return axios.post(`${BASE_URL}/answer`, payload);
}

function* fetchAnswerChatSaga(action) {
    try {
        const response = yield call(answerChatSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: ChatActionTypes.ANSWER_CHAT_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: ChatActionTypes.ANSWER_CHAT_FAILURE, payload: error.message });
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

export default function* chatSaga() {
    yield takeLatest(ChatActionTypes.ANSWER_CHAT_REQUEST, fetchAnswerChatSaga);
    yield takeLatest(ChatActionTypes.GET_CHAT_HISTORY_REQUEST, fetchGetChatHistorySaga);
    yield takeLatest(ChatActionTypes.GET_CHAT_BY_ID_REQUEST, fetchGetChatByIdSaga);
    yield takeLatest(ChatActionTypes.GET_ALL_CHATS_REQUEST, fetchGetAllChatsSaga);
    yield takeLatest(ChatActionTypes.GET_CHATS_BY_USER_REQUEST, fetchGetChatsByUserSaga);
}
