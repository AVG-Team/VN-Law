import { call, put, takeLatest } from "redux-saga/effects";
import { VbqpplActionTypes } from "../actions/vbqpplAction";
import axios from "../../../config/axios";

const BASE_URL = "http://localhost:9002/law/api/vbqppl";

function getAllByPageSaga(params) {
    const token = localStorage.getItem('accessToken');
    return axios.get(`${BASE_URL}`, { params, headers: {
            Authorization: `Bearer ${token}`,
        }, });
}

function* fetchGetAllByPageSaga(action) {
    try {
        const response = yield call(getAllByPageSaga, action.payload);
        console.log("response", response);
        yield put({ type: VbqpplActionTypes.GET_ALL_BY_PAGE_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: VbqpplActionTypes.GET_ALL_BY_PAGE_FAILURE, payload: error.message });
    }
}

function getByIdSaga(vbqpplId) {
    return axios.get(`${BASE_URL}/${vbqpplId}`);
}

function* fetchGetByIdSaga(action) {
    try {
        const vbqpplId = action.payload;
        const response = yield call(getByIdSaga, vbqpplId);
        console.log("response", response.data);
        yield put({ type: VbqpplActionTypes.GET_VBQPPL_BY_ID_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: VbqpplActionTypes.GET_VBQPPL_BY_ID_FAILURE, payload: error.message });
    }
}

function getAllSaga() {
    return axios.get(`${BASE_URL}/all`);
}

function* fetchGetAllSaga() {
    try {
        const response = yield call(getAllSaga, action.payload);
        console.log("response", response);
        yield put({ type: VbqpplActionTypes.GET_ALL_VBQPPL_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: VbqpplActionTypes.GET_ALL_VBQPPL_FAILURE, payload: error.message });
    }
}
function filterSaga(params) {
    return axios.get(`${BASE_URL}/filter`, { params });
}

function* fetchFilterSaga(action) {
    try {
        const response = yield call(filterSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: VbqpplActionTypes.FILTER_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: VbqpplActionTypes.FILTER_FAILURE, payload: error.message });
    }
}

export default function* vbqpplSaga() {
    yield takeLatest(VbqpplActionTypes.GET_ALL_VBQPPL_BY_PAGE_REQUEST, fetchGetAllByPageSaga);
    yield takeLatest(VbqpplActionTypes.GET_VBQPPL_BY_ID_REQUEST, fetchGetByIdSaga);
    yield takeLatest(VbqpplActionTypes.GET_ALL_VBQPPL_REQUEST, fetchGetAllSaga);
    yield takeLatest(VbqpplActionTypes.FILTER_REQUEST, fetchFilterSaga);
}
