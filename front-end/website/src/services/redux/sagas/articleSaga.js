import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { ArticleActionTypes } from "../actions/articleAction";

const BASE_URL = "http://localhost:9002/law/api/article";

function getAllByPageSaga(params) {
    return axios.get(`${BASE_URL}/filter`, { params });
}
function* fetchGetAllByPageSaga(action) {
    try {
        const response = yield call(getAllByPageSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: ArticleActionTypes.GET_ALL_ARTICLES_BY_PAGE_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: ArticleActionTypes.GET_ALL_ARTICLES_BY_PAGE_FAILURE, payload: error.message });
    }
}

function getByChapterIdSaga(param) {
    return axios.get(`${BASE_URL}/${param}`);
}

function* fetchGetByChapterIdSaga(action) {
    try {
        const response = yield call(getByChapterIdSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: ArticleActionTypes.GET_BY_CHAPTER_ID_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: ArticleActionTypes.GET_BY_CHAPTER_ID_FAILURE, payload: error.message });
    }
}

function getTreeArticleSaga(param) {
    return axios.get(`${BASE_URL}/tree/${param}`);
}
function* fetchGetTreeArticleSaga(action) {
    try {
        const response = yield call(getTreeArticleSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: ArticleActionTypes.GET_TREE_ARTICLE_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: ArticleActionTypes.GET_TREE_ARTICLE_FAILURE, payload: error.message });
    }
}

export default function* articleSaga() {
    yield takeLatest(ArticleActionTypes.GET_ALL_ARTICLES_BY_PAGE_REQUEST, fetchGetAllByPageSaga);
    yield takeLatest(ArticleActionTypes.GET_BY_CHAPTER_ID_REQUEST, fetchGetByChapterIdSaga);
    yield takeLatest(ArticleActionTypes.GET_TREE_ARTICLE_REQUEST, fetchGetTreeArticleSaga);
}

export { getAllByPageSaga, getByChapterIdSaga, getTreeArticleSaga };
