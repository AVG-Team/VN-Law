import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { ChapterActionTypes } from "../actions/chapterActions";

const urlLaw = "law/api/chapter";

function* getAllByPageSaga(action) {
    try {
        const response = yield call(axios.get, urlLaw, { params: action.payload });
        yield put({ type: ChapterActionTypes.GET_ALL_BY_PAGE_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: ChapterActionTypes.GET_ALL_BY_PAGE_FAILURE, payload: error.message });
    }
}

function* getByChapterIdSaga(action) {
    try {
        const response = yield call(axios.get, `${urlLaw}/${action.payload}`);
        yield put({ type: ChapterActionTypes.GET_BY_ID_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: ChapterActionTypes.GET_BY_ID_FAILURE, payload: error.message });
    }
}

function* getBySubject(action) {
    try {
        const response = yield call(axios.get, `${urlLaw}/${action.payload}`);
        yield put({ type: ChapterActionTypes.GET_BY_SUBJECT_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: ChapterActionTypes.GET_BY_SUBJECT_FAILURE, payload: error.message });
    }
}

function* getAll() {
    try {
        const response = yield call(axios.get, `${urlLaw}`);
        yield put({ type: ChapterActionTypes.GET_ALL_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: ChapterActionTypes.GET_ALL_FAILURE, payload: error.message });
    }
}

export default function* chapterSaga() {
    yield takeLatest(ChapterActionTypes.GET_ALL_BY_PAGE_REQUEST, getAllByPageSaga);
    yield takeLatest(ChapterActionTypes.GET_BY_ID_REQUEST, getByChapterIdSaga);
    yield takeLatest(ChapterActionTypes.GET_BY_SUBJECT_REQUEST, getBySubject);
    yield takeLatest(ChapterActionTypes.GET_ALL_REQUEST, getAll);
}
