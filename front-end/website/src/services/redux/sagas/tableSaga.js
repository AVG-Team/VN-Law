import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { TableActionTypes } from "../actions/tableAction";
import { LAW_API_BASE_URL } from "~/common/constants/keys";


const BASE_URL = LAW_API_BASE_URL + "/table";


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
