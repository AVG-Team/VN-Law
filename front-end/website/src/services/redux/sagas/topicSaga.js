import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { TopicActionTypes } from "../actions/topicActions";

const urlLaw = "law/api/topic";

function* getAllByPageSaga(action) {
    try {
        const response = yield call(axios.get, urlLaw, { params: action.payload });
        yield put({ type: TopicActionTypes.GET_ALL_BY_PAGE_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: TopicActionTypes.GET_ALL_BY_PAGE_FAILURE, payload: error.message });
    }
}

function* getByTopicIdSaga(action) {
    try {
        const response = yield call(axios.get, `${urlLaw}/${action.payload}`);
        yield put({ type: TopicActionTypes.GET_BY_ID_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: TopicActionTypes.GET_BY_ID_FAILURE, payload: error.message });
    }
}

export default function* topicSaga() {
    yield takeLatest(TopicActionTypes.GET_ALL_BY_PAGE_REQUEST, getAllByPageSaga);
    yield takeLatest(TopicActionTypes.GET_BY_ID_REQUEST, getBySubjectIdSaga);
}
