import axiosClient from "../axiosClient";

const urlLaw = "law/topic";
const topicApi = {
    getAll() {
        return axiosClient.get(urlLaw);
    },
    getById(id) {
        const url = urlLaw + `/${id}`;
        return axiosClient.get(url, { id });
    },
};

export default topicApi;
