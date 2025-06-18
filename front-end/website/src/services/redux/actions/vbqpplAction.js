export const VbqpplActionTypes = {
    GET_ALL_VBQPPL_BY_PAGE_REQUEST: "GET_ALL_VBQPPL_BY_PAGE_REQUEST",
    GET_ALL_VBQPPL_BY_PAGE_SUCCESS: "GET_ALL_VBQPPL_BY_PAGE_SUCCESS",
    GET_ALL_VBQPPL_BY_PAGE_FAILURE: "GET_ALL_VBQPPL_BY_PAGE_FAILURE",

    GET_VBQPPL_BY_ID_REQUEST: "GET_VBQPPL_BY_ID_REQUEST",
    GET_VBQPPL_BY_ID_SUCCESS: "GET_VBQPPL_BY_ID_SUCCESS",
    GET_VBQPPL_BY_ID_FAILURE: "GET_VBQPPL_BY_ID_FAILURE",

    GET_ALL_VBQPPL_REQUEST: "GET_ALL_VBQPPL_REQUEST",
    GET_ALL_VBQPPL_SUCCESS: "GET_ALL_VBQPPL_SUCCESS",
    GET_ALL_VBQPPL_FAILURE: "GET_ALL_VBQPPL_FAILURE",

    FILTER_REQUEST: "FILTER_REQUEST",
    FILTER_SUCCESS: "FILTER_SUCCESS",
    FILTER_FAILURE: "FILTER_FAILURE",
};

export const getAllByPage = (params) => ({
    type: VbqpplActionTypes.GET_ALL_BY_PAGE_REQUEST,
    payload: params,
});

export const getById = (vbqpplId) => ({
    type: VbqpplActionTypes.GET_VBQPPL_BY_ID_REQUEST,
    payload: vbqpplId,
});

export const getAll = () => ({
    type: VbqpplActionTypes.GET_ALL_VBQPPL_REQUEST,
});

export const filter = (params) => ({
    type: VbqpplActionTypes.FILTER_REQUEST,
    payload: params,
});
