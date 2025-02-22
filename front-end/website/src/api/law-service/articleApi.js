import axiosClient from "../axiosClient";

const urlLaw = "law/article";
const articleApi = {
    getByChapterId(chapterId) {
        const url = urlLaw + `/chapter/${chapterId}`;
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
