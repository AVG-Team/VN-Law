import axiosClient from "../axiosClient";

const urlLaw = "law/chapter";
const chapterApi = {
    getAll() {
        return axiosClient.get(urlLaw);
    },
    getAllByPage(params) {
        const url = urlLaw + "/filter";
        return axiosClient.get(url, { params });
    },
    getById(id) {
        const url = urlLaw + `/${id}`;
        return axiosClient.get(url, { id });
    },
    getBySubject(idSubject) {
        const url = urlLaw + `/subject/${idSubject}`;
        return axiosClient.get(url, { idSubject });
    },
};

export default chapterApi;
