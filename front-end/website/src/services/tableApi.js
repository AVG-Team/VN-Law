import axios from "~/config/axios";

const urlLaw = "law/api/v1/table";

const tableApi = {
    getAll(params) {
        const url = urlLaw + "/all";
        return axios.get(url, { params });
    },
};

export default tableApi;
