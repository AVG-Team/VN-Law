export const ArticleActionTypes = {
    GET_BY_CHAPTER_ID_REQUEST: "GET_BY_CHAPTER_ID_REQUEST",
    GET_BY_CHAPTER_ID_SUCCESS: "GET_BY_CHAPTER_ID_SUCCESS",
    GET_B_CHAPTER_ID_FAILURE: "GET_BY_CHAPTER_ID_FAILURE",

    GET_TREE_ARTICLE_REQUEST: "GET_TREE_ARTICLE_REQUEST",
    GET_TREE_ARTICLE_SUCCESS: "GET_TREE_ARTICLE_SUCCESS",
    GET_TREE_ARTICLE_FAILURE: "GET_TREE_ARTICLE_FAILURE",

    GET_ALL_ARTICLES_BY_PAGE_REQUEST: "GET_ALL_ARTICLES_BY_PAGE_REQUEST",
    GET_ALL_ARTICLES_BY_PAGE_SUCCESS: "GET_ALL_ARTICLES_BY_PAGE_SUCCESS",
    GET_ALL_ARTICLES_BY_PAGE_FAILURE: "GET_ALL_ARTICLES_BY_PAGE_FAILURE",
};

export const getByChapterId = (chapterId) => ({
    type: ArticelActionTypes.GET_BY_CHAPTER_ID_REQUEST,
    payload: chapterId,
});

export const getTreeArticle = (articleId) => ({
    type: ArticelActionTypes.GET_TREE_ARTICLE_REQUEST,
    payload: articleId,
});

export const getAllByPage = (params) => ({
    type: ArticelActionTypes.GET_ALL_ARTICLES_BY_PAGE_REQUEST,
    payload: params,
});
