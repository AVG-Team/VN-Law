import axiosClient from "../axiosClient";


const urlLaw = "law/api/v1/table";

const tableApi = {
    getAll(params) {
        const url = urlLaw + "/all";
        return axiosClient.get(url, { params} );
    }
};

export default tableApi;