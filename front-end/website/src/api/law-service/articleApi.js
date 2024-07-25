import axiosClient from "../axiosClient";

const urlLaw = "law/api/v1/article";
const articleApi = {
    getByChapterId(chapterId) {
        const url = urlLaw + `/${chapterId}`;
        return axiosClient.get(url, { chapterId });
    },

    getTreeArticle(articleId) {
        const url = urlLaw + `/tree/${articleId}`;
        return axiosClient.get(url, { articleId });
    },
    getAllByPage(params) {
        const url = urlLaw + "/filter";
        return axiosClient.get(url, { params });
    },
};

export default articleApi;
