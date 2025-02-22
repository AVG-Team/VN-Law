import axiosClient from "../axiosClient";

const urlLaw = "law/subject";

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
        const url = urlLaw + `/topic/${idTopic}`;
        return axiosClient.get(url, { idTopic });
    },
};

export default subjectApi;
