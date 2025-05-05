export const ChapterActionTypes = {
    GET_ALL_BY_PAGE_REQUEST: "GET_ALL_BY_PAGE_REQUEST",
    GET_ALL_BY_PAGE_SUCCESS: "GET_ALL_BY_PAGE_SUCCESS",
    GET_ALL_BY_PAGE_FAILURE: "GET_ALL_BY_PAGE_FAILURE",

    GET_BY_ID_REQUEST: "GET_BY_ID_REQUEST",
    GET_BY_ID_SUCCESS: "GET_BY_ID_SUCCESS",
    GET_BY_ID_FAILURE: "GET_BY_ID_FAILURE",

    GET_ALL_REQUEST: "GET_ALL_REQUEST",
    GET_ALL_SUCCESS: "GET_ALL_SUCCESS",
    GET_ALL_FAILURE: "GET_ALL_FAILURE",

    GET_BY_SUBJECT_REQUEST: "GET_BY_SUBJECT_REQUEST",
    GET_BY_SUBJECT_SUCCESS: "GET_BY_SUBJECT_SUCCESS",
    GET_BY_SUBJECT_FAILURE: "GET_BY_SUBJECT_FAILURE",
};

export const getAllByPage = (params) => ({
    type: ChapterActionTypes.GET_ALL_BY_PAGE_REQUEST,
    payload: params,
});

export const getById = (chapterId) => ({
    type: ChapterActionTypes.GET_BY_ID_REQUEST,
    payload: chapterId,
});

export const getAll = () => ({
    type: ChapterActionTypes.GET_ALL_REQUEST,
});

export const getBySubject = (subjectId) => ({
    type: ChapterActionTypes.GET_BY_SUBJECT_REQUEST,
    payload: subjectId,
});
