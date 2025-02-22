import axiosClient from "../axiosClient";

const urlLaw = "law/vbqppl";
const VbqpplApi = {
    getAllByPage(params) {
        return axiosClient.get(urlLaw, { params });
    },
    getById(vbqpplId) {
        const url = urlLaw + `/${vbqpplId}`;
        return axiosClient.get(url, { vbqpplId });
    },
    getAll() {
        return axiosClient.get(urlLaw + "/all");
    },
    filter(params) {
        return axiosClient.get(urlLaw + "/filter", { params });
    },
};

export default VbqpplApi;
