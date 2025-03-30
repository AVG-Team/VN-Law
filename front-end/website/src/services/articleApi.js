import axios from "~/config/axios";

const urlLaw = "law/api/v1/article";
const articleApi = {
    getByChapterId(chapterId) {
        const url = urlLaw + `/${chapterId}`;
        return axios.get(url, { chapterId });
    },

    getTreeArticle(articleId) {
        const url = urlLaw + `/tree/${articleId}`;
        return axios.get(url, { articleId });
    },
    getAllByPage(params) {
        const url = urlLaw + "/filter";
        return axios.get(url, { params });
    },
};

export default articleApi;
