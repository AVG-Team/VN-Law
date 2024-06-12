import axiosClient from "../axiosClient";

const VbqpplApi = {
    getAllByPage(params) {
        const url = "/law-service/vbqppl";
        return axiosClient.get(url, { params });
    },
    getById(vbqpplId) {
        const url = `/law-service/vbqppl/${vbqpplId}`;
        return axiosClient.get(url, { vbqpplId });
    },
    getAll() {
        return axiosClient.get("/law-service/vbqppl/all");
    },
    filter(params) {
        return axiosClient.get("/law-service/vbqppl/filter", { params });
    },
};

export default VbqpplApi;
