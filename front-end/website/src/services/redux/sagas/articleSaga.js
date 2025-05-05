import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { AritcleActionTypes } from "../actions/articleActions";

const urlLaw = "law/api/article";

function* getAllByPageSaga(action) {
    try {
        const response = yield call(axios.get, urlLaw, { params: action.payload });
        yield put({ type: AritcleActionTypes.GET_ALL_BY_PAGE_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: AritcleActionTypes.GET_ALL_BY_PAGE_FAILURE, payload: error.message });
    }
}

function* getByChapterIdSaga(action) {
    try {
        const response = yield call(axios.get, `${urlLaw}/${action.payload}`);
        yield put({ type: AritcleActionTypes.GET_BY_CHAPTER_ID_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: AritcleActionTypes.GET_BY_CHAPTER_ID_FAILURE, payload: error.message });
    }
}

function* getTreeArticleSaga(action) {
    try {
        const response = yield call(axios.get, `${urlLaw}/${action.payload}`);
        yield put({ type: AritcleActionTypes.GET_TREE_ARTICLE_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: AritcleActionTypes.GET_TREE_ARTICLE_FAILURE, payload: error.message });
    }
}

export default function* articleSaga() {
    yield takeLatest(AritcleActionTypes.GET_ALL_BY_PAGE_REQUEST, getAllByPageSaga);
    yield takeLatest(AritcleActionTypes.GET_BY_CHAPTER_ID_REQUEST, getByChapterIdSaga);
    yield takeLatest(AritcleActionTypes.GET_TREE_ARTICLE_REQUEST, getTreeArticleSaga);
}
