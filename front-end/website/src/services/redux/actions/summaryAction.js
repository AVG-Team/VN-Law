export const SummaryActionTypes = {
    SUMMARY_DOCUMENT_REQUEST: "SUMMARY_DOCUMENT_REQUEST",
    SUMMARY_DOCUMENT_SUCCESS: "SUMMARY_DOCUMENT_SUCCESS",
    SUMMARY_DOCUMENT_FAILURE: "SUMMARY_DOCUMENT_FAILURE",
};

export const summaryDocumentRequest = (document) => ({
    type: SummaryActionTypes.SUMMARY_DOCUMENT_REQUEST,
    payload: { document },
});
