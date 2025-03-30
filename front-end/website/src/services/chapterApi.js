import axios from "~/config/axios";

const urlLaw = "law/api/v1/chapter";
const chapterApi = {
    getAll() {
        return axios.get(urlLaw);
    },
    getAllByPage(params) {
        const url = urlLaw + "/filter";
        return axios.get(url, { params });
    },
    getById(id) {
        const url = urlLaw + `/${id}`;
        return axios.get(url, { id });
    },
    getBySubject(idSubject) {
        const url = urlLaw + `/subject/${idSubject}`;
        return axios.get(url, { idSubject });
    },
};

export default chapterApi;
