import axiosClient from "../axiosClient";

const chapterApi = {
    getAll() {
        const url = "/law-service/chapter";
        return axiosClient.get(url);
    },
    getAllByPage(params) {
        const url = "/law-service/chapter/filter";
        return axiosClient.get(url, { params });
    },
    getById(id) {
        const url = `/law-service/chapter/${id}`;
        return axiosClient.get(url, { id });
    },
    getBySubject(idSubject) {
        const url = `/law-service/chapter/subject/${idSubject}`;
        return axiosClient.get(url, { idSubject });
    },
};

export default chapterApi;
