import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { TableActionTypes } from "../actions/tableAction";

const BASE_URL = "http://localhost:9002/law/api/table";

function getAllByPageSaga(params) {
    return axios.get(`${BASE_URL}`, { params });
}
function* fetchGetAllByPageSaga(action) {
    try {
        const response = yield call(getAllByPageSaga, action.payload);
        console.log("response", response.data);
        yield put({ type: TableActionTypes.GET_ALL_TABLES_SUCCESS, payload: response });
    } catch (error) {
        yield put({ type: TableActionTypes.GET_ALL_TABLES_FAILURE, payload: error.message });
    }
}

export default function* tableSaga() {
    yield takeLatest(TableActionTypes.GET_ALL_TABLES_REQUEST, fetchGetAllByPageSaga);
}
