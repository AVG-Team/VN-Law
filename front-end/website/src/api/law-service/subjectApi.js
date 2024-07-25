import axiosClient from "../axiosClient";

const urlLaw = "law/api/v1/subject";

const subjectApi = {
    getAllByPage(params) {
        return axiosClient.get(urlLaw, { params });
    },

    getAll() {
        return axiosClient.get(urlLaw);
    },

    getById(id) {
        const url = urlLaw + `/${id}`;
        return axiosClient.get(url, { id });
    },

    getByTopic(idTopic) {
        const url = urlLaw + `/${idTopic}`;
        return axiosClient.get(url, { idTopic });
    },
};

export default subjectApi;
