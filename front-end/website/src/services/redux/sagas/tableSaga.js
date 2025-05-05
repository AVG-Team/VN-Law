import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { TableActionTypes } from "../actions/tableActions";

const urlLaw = "law/api/table";

function* getAllByPageSaga(action) {
    try {
        const response = yield call(axios.get, urlLaw, { params: action.payload });
        yield put({ type: TableActionTypes.GET_ALL_SUCCESS, payload: response.data });
    } catch (error) {
        yield put({ type: TableActionTypes.GET_ALL_FAILURE, payload: error.message });
    }
}

export default function* tableSaga() {
    yield takeLatest(TableActionTypes.GET_ALL_BY_PAGE_REQUEST, getAllByPageSaga);
}
