import axios from "~/config/axios";

const urlLaw = "law/api/v1/vbqppl";
const VbqpplApi = {
    getAllByPage(params) {
        return axios.get(urlLaw, { params });
    },
    getById(vbqpplId) {
        const url = urlLaw + `/${vbqpplId}`;
        return axios.get(url, { vbqpplId });
    },
    getAll() {
        return axios.get(urlLaw + "/all");
    },
    filter(params) {
        return axios.get(urlLaw + "/filter", { params });
    },
};

export default VbqpplApi;
