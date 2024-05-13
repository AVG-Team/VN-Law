import axiosClient from "../axiosClient";

const subjectApi = {
    getAllByPage(params) {
        const url = "/law-service/subject";
        return axiosClient.get(url, { params });
    },

    getAll() {
        const url = "/law-service/subject";
        return axiosClient.get(url);
    },

    getById(id) {
        const url = `/law-service/subject/${id}`;
        return axiosClient.get(url, { id });
    },

    getByTopic(idTopic) {
        const url = `/law-service/subject/topic/${idTopic}`;
        return axiosClient.get(url, { idTopic });
    },
};

export default subjectApi;
