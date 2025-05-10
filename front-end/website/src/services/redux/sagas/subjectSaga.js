import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { SubjectActionTypes } from "../actions/subjectAction";

const BASE_URL = "http://localhost:9002/law/api/subject";

function getAllByPageSaga(params) {
    return axios.get(`${BASE_URL}`, { params });
}

function* fetchGetAllByPageSaga(action) {
    try {
        const response = yield call(getAllByPageSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: SubjectActionTypes.GET_ALL_SUBJECTS_BY_PAGE_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: SubjectActionTypes.GET_ALL_SUBJECTS_BY_PAGE_FAILURE, payload: error.message });
    }
}

function getBySubjectIdSaga(param) {
    return axios.get(`${BASE_URL}/${param}`);
}
function* fetchGetBySubjectIdSaga(action) {
    try {
        const response = yield call(getBySubjectIdSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: SubjectActionTypes.GET_BY_SUBJECT_ID_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: SubjectActionTypes.GET_BY_SUBJECT_ID_FAILURE, payload: error.message });
    }
}

function getByTopicSaga(param) {
    return axios.get(`${BASE_URL}/topic/${param}`);
}

function* fetchGetByTopic(action) {
    try {
        const response = yield call(getByTopicSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: SubjectActionTypes.GET_BY_TOPIC_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: SubjectActionTypes.GET_BY_TOPIC_FAILURE, payload: error.message });
    }
}

export default function* subjectSaga() {
    yield takeLatest(SubjectActionTypes.GET_ALL_SUBJECTS_BY_PAGE_REQUEST, fetchGetAllByPageSaga);
    yield takeLatest(SubjectActionTypes.GET_BY_SUBJECT_ID_REQUEST, fetchGetBySubjectIdSaga);
    yield takeLatest(SubjectActionTypes.GET_BY_TOPIC_REQUEST, fetchGetByTopic);
}

export { getAllByPageSaga, getBySubjectIdSaga, getByTopicSaga };
