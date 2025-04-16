import axios from "~/config/axios";

const urlLaw = "law/api/v1/subject";

const subjectApi = {
    getAllByPage(params) {
        return axios.get(urlLaw, { params });
    },

    getAll() {
        return axios.get(urlLaw);
    },

    getById(id) {
        const url = urlLaw + `/${id}`;
        return axios.get(url, { id });
    },

    getByTopic(idTopic) {
        const url = urlLaw + `/${idTopic}`;
        return axios.get(url, { idTopic });
    },
};

export default subjectApi;
