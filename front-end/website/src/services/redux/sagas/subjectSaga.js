import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { SubjectActionTypes } from "../actions/subjectActions";

const urlLaw = "law/api/subject";

function* getAllByPageSaga(action) {
    try {
        const response = yield call(axios.get, urlLaw, { params: action.payload });
        yield put({ type: SubjectActionTypes.GET_ALL_BY_PAGE_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: SubjectActionTypes.GET_ALL_BY_PAGE_FAILURE, payload: error.message });
    }
}

function* getBySubjectIdSaga(action) {
    try {
        const response = yield call(axios.get, `${urlLaw}/${action.payload}`);
        yield put({ type: SubjectActionTypes.GET_BY_ID_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: SubjectActionTypes.GET_BY_ID_FAILURE, payload: error.message });
    }
}

function* getByTopic(action) {
    try {
        const response = yield call(axios.get, `${urlLaw}/${action.payload}`);
        yield put({ type: SubjectActionTypes.GET_BY_TOPIC_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: SubjectActionTypes.GET_BY_TOPIC_FAILURE, payload: error.message });
    }
}

export default function* subjectSaga() {
    yield takeLatest(SubjectActionTypes.GET_ALL_BY_PAGE_REQUEST, getAllByPageSaga);
    yield takeLatest(SubjectActionTypes.GET_BY_ID_REQUEST, getBySubjectIdSaga);
    yield takeLatest(SubjectActionTypes.GET_BY_TOPIC_REQUEST, getByTopic);
}
