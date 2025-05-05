export const TableActionTypes = {
    GET_ALL_REQUEST: "GET_ALL_REQUEST",
    GET_ALL_SUCCESS: "GET_ALL_SUCCESS",
    GET_ALL_FAILURE: "GET_ALL_FAILURE",
};

export const getAll = () => ({
    type: TableActionTypes.GET_ALL_REQUEST,
});
