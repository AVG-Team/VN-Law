import axiosClient from "../axiosClient";

const topicApi = {
    getAll() {
        const url = "/law-service/topic";
        return axiosClient.get(url);
    },
    getById(id) {
        const url = `/law-service/topic/${id}`;
        return axiosClient.get(url, { id });
    },
};

export default topicApi;
