import axiosClient from "../axiosClient";

const articleApi = {
    getByChapterId(chapterId) {
        const url = `/law-service/article/chapter/${chapterId}`;
        return axiosClient.get(url, { chapterId });
    },

    getTreeArticle(articleId) {
        const url = `/law-service/article/tree/${articleId}`;
        return axiosClient.get(url, { articleId });
    },
    getAllByPage(params) {
        const url = "/law-service/article/filter";
        return axiosClient.get(url, { params });
    },
};

export default articleApi;
