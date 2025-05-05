import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { VbqpplActionTypes } from "../actions/vbqpplActions";

const urlLaw = "law/api/v1/vbqppl";

function* getAllByPageSaga(action) {
    try {
        const response = yield call(axios.get, urlLaw, { params: action.payload });
        yield put({ type: VbqpplActionTypes.GET_ALL_BY_PAGE_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: VbqpplActionTypes.GET_ALL_BY_PAGE_FAILURE, payload: error.message });
    }
}

function* getByIdSaga(action) {
    try {
        const response = yield call(axios.get, `${urlLaw}/${action.payload}`);
        yield put({ type: VbqpplActionTypes.GET_BY_ID_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: VbqpplActionTypes.GET_BY_ID_FAILURE, payload: error.message });
    }
}

function* getAllSaga() {
    try {
        const response = yield call(axios.get, `${urlLaw}/all`);
        yield put({ type: VbqpplActionTypes.GET_ALL_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: VbqpplActionTypes.GET_ALL_FAILURE, payload: error.message });
    }
}

function* filterSaga(action) {
    try {
        const response = yield call(axios.get, `${urlLaw}/filter`, { params: action.payload });
        yield put({ type: VbqpplActionTypes.FILTER_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: VbqpplActionTypes.FILTER_FAILURE, payload: error.message });
    }
}

export default function* vbqpplSaga() {
    yield takeLatest(VbqpplActionTypes.GET_ALL_BY_PAGE_REQUEST, getAllByPageSaga);
    yield takeLatest(VbqpplActionTypes.GET_BY_ID_REQUEST, getByIdSaga);
    yield takeLatest(VbqpplActionTypes.GET_ALL_REQUEST, getAllSaga);
    yield takeLatest(VbqpplActionTypes.FILTER_REQUEST, filterSaga);
}
