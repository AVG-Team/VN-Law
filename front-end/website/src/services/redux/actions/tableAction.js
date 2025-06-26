export const TableActionTypes = {
    GET_ALL_TABLES_REQUEST: "GET_ALL_TABLES_REQUEST",
    GET_ALL_TABLES_SUCCESS: "GET_ALL_TABLES_SUCCESS",
    GET_ALL_TABLES_FAILURE: "GET_ALL_TABLES_FAILURE",
};

export const getAll = () => ({
    type: TableActionTypes.GET_ALL_TABLES_REQUEST,
});
