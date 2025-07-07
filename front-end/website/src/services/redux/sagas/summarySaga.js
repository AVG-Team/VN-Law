import { SummaryActionTypes } from "../actions/summaryAction";
import { call, put, takeLatest } from "redux-saga/effects";
import axios from "~/config/axios";
import { CHAT_API_BASE_URL } from "~/common/constants/keys";

const BASE_URL = CHAT_API_BASE_URL;

async function summaryDocumentSaga(payload) {
    try {
        const { document } = payload || {};
        const response = await axios.post(`${BASE_URL}/api/chat/summarize`, {
            document,
        });
        return response.data;
    } catch (error) {
        throw new Error(error?.response?.data?.message || "Lỗi kết nối đến server");
    }
}

function* fetchSummaryDocumentSaga(action) {
    try {
        const { document } = action.payload.document;

        // Gọi API
        const response = yield call(summaryDocumentSaga, { document });

        // Cập nhật kết quả tóm tắt
        yield put({
            type: SummaryActionTypes.SUMMARY_DOCUMENT_SUCCESS,
            payload: { summary_document: response.summary },
        });
    } catch (error) {
        yield put({
            type: SummaryActionTypes.SUMMARY_DOCUMENT_FAILURE,
            payload: { error: error.message },
        });
    }
}

export default function* summarySaga() {
    yield takeLatest(SummaryActionTypes.SUMMARY_DOCUMENT_REQUEST, fetchSummaryDocumentSaga);
}
