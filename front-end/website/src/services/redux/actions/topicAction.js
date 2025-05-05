export const TopicActionTypes = {
    GET_BY_ID_REQUEST: "GET_BY_ID_REQUEST",
    GET_BY_ID_SUCCESS: "GET_BY_ID_SUCCESS",
    GET_BY_ID_FAILURE: "GET_BY_ID_FAILURE",

    GET_ALL_REQUEST: "GET_ALL_REQUEST",
    GET_ALL_SUCCESS: "GET_ALL_SUCCESS",
    GET_ALL_FAILURE: "GET_ALL_FAILURE",
};

export const getById = (topidId) => ({
    type: TopicActionTypes.GET_BY_ID_REQUEST,
    payload: vbqpplId,
});

export const getAll = () => ({
    type: TopicActionTypes.GET_ALL_REQUEST,
});
