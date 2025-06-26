import { SummaryActionTypes } from "../actions/summaryAction";

const initialState = {
    loading: false,
    error: null,
    summary_document: null,
};

const summaryReducer = (state = initialState, action) => {
    switch (action.type) {
        case SummaryActionTypes.SUMMARY_DOCUMENT_REQUEST:
            return {
                ...state,
                loading: true,
                error: null,
                summary_document: null,
            };
        case SummaryActionTypes.SUMMARY_DOCUMENT_SUCCESS:
            return {
                ...state,
                loading: false,
                summary_document: action.payload.summary_document,
            };
        case SummaryActionTypes.SUMMARY_DOCUMENT_FAILURE:
            return {
                ...state,
                loading: false,
                error: action.payload.error,
            };
        default:
            return state;
    }
};

export default summaryReducer;
