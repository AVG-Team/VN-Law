import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { ChapterActionTypes } from "../actions/chapterAction";

const BASE_URL = "http://localhost:9002/law/api/chapter";

function getAllByPageSaga(params) {
    return axios.get(`${BASE_URL}/filter`, { params });
}
function* fetchGetAllByPageSaga(action) {
    try {
        const response = yield call(getAllByPageSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: ChapterActionTypes.GET_ALL_CHAPTERS_BY_PAGE_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: ChapterActionTypes.GET_ALL_CHAPTERS_BY_PAGE_FAILURE, payload: error.message });
    }
}

function getByChapterIdSaga(param) {
    return axios.get(`${BASE_URL}/${param}`);
}

function* fetchGetByChapterIdSaga(action) {
    try {
        const response = yield call(getByChapterIdSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: ChapterActionTypes.GET_BY_CHAPTER_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: ChapterActionTypes.GET_BY_CHAPTER_FAILURE, payload: error.message });
    }
}

function getBySubjectSaga(param) {
    return axios.get(`${BASE_URL}/subject/${param}`);
}

function* fetchGetBySubject(action) {
    try {
        const response = yield call(getBySubjectSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: ChapterActionTypes.GET_BY_SUBJECT_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: ChapterActionTypes.GET_BY_SUBJECT_FAILURE, payload: error.message });
    }
}

function getAllSaga() {
    return axios.get(`${BASE_URL}`);
}

function* fetchGetAllSaga() {
    try {
        const response = yield call(getAllSaga);
        console.log("response", response.data);
        yield put({ type: ChapterActionTypes.GET_ALL_CHAPTERS_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: ChapterActionTypes.GET_ALL_CHAPTERS_FAILURE, payload: error.message });
    }
}

export default function* chapterSaga() {
    yield takeLatest(ChapterActionTypes.GET_ALL_CHAPTERS_BY_PAGE_REQUEST, fetchGetAllByPageSaga);
    yield takeLatest(ChapterActionTypes.GET_BY_CHAPTER_REQUEST, fetchGetByChapterIdSaga);
    yield takeLatest(ChapterActionTypes.GET_BY_SUBJECT_REQUEST, fetchGetBySubject);
    yield takeLatest(ChapterActionTypes.GET_ALL_CHAPTERS_REQUEST, fetchGetAllSaga);
}
export { getAllByPageSaga, getByChapterIdSaga, getBySubjectSaga, getAllSaga };
