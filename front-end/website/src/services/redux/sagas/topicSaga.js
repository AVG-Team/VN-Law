import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { TopicActionTypes } from "../actions/topicAction";
import { LAW_API_BASE_URL } from "~/common/constants/keys";

const BASE_URL = LAW_API_BASE_URL + "/topic";

function getAllSaga(params) {
    return axios.get(`${BASE_URL}`, { params });
}
function* fetchGetAllSaga(action) {
    try {
        const response = yield call(getAllSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: TopicActionTypes.GET_ALL_TOPICS_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: TopicActionTypes.GET_ALL_TOPICS_FAILURE, payload: error.message });
    }
}

function getByTopicIdSaga(param) {
    return axios.get(`${BASE_URL}/${param}`);
}

function* fetchGetByTopicIdSaga(action) {
    try {
        const response = yield call(getByTopicIdSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: TopicActionTypes.GET_BY_TOPIC_ID_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: TopicActionTypes.GET_BY_TOPIC_ID_FAILURE, payload: error.message });
    }
}

export default function* topicSaga() {
    yield takeLatest(TopicActionTypes.GET_ALL_TOPICS_REQUEST, fetchGetAllSaga);
    yield takeLatest(TopicActionTypes.GET_BY_TOPIC_ID_REQUEST, fetchGetByTopicIdSaga);
}
export { getAllSaga, getByTopicIdSaga };
