import axiosClient from "../axiosClient";

const tableApi = {
    getAll(params) {
        const url = "/law-service/table/all";
        return axiosClient.get(url, { params} );
    }
};

export default tableApi;