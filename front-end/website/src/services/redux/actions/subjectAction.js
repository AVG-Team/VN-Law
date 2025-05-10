export const SubjectActionTypes = {
    GET_ALL_SUBJECTS_BY_PAGE_REQUEST: "GET_ALL_SUBJECTS_BY_PAGE_REQUEST",
    GET_ALL_SUBJECTS_BY_PAGE_SUCCESS: "GET_ALL_SUBJECTS_BY_PAGE_SUCCESS",
    GET_ALL_SUBJECTS_BY_PAGE_FAILURE: "GET_ALL_SUBJECTS_BY_PAGE_FAILURE",

    GET_BY_SUBJECT_ID_REQUEST: "GET_BY_SUBJECT_ID_REQUEST",
    GET_BY_SUBJECT_ID_SUCCESS: "GET_BY_SUBJECT_ID_SUCCESS",
    GET_BY_SUBJECT_ID_FAILURE: "GET_BY_SUBJECT_ID_FAILURE",

    GET_BY_TOPIC_REQUEST: "GET_BY_TOPIC_REQUEST",
    GET_BY_TOPIC_SUCCESS: "GET_BY_TOPIC_SUCCESS",
    GET_BY_TOPIC_FAILURE: "GET_BY_TOPIC_FAILURE",
};

export const getAllByPage = (params) => ({
    type: SubjectActionTypes.GET_ALL_SUBJECTS_BY_PAGE_REQUEST,
    payload: params,
});

export const getById = (subjectId) => ({
    type: SubjectActionTypes.GET_BY_SUBJECT_ID_REQUEST,
    payload: subjectId,
});

export const getByTopic = (topicId) => ({
    type: SubjectActionTypes.GET_BY_TOPIC_REQUEST,
    payload: topicId,
});
