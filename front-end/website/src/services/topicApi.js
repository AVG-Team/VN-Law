import axios from "~/config/axios";

const urlLaw = "law/api/v1/topic";
const topicApi = {
    getAll() {
        return axios.get(urlLaw);
    },
    getById(id) {
        const url = urlLaw + `/${id}`;
        return axios.get(url, { id });
    },
};

export default topicApi;
