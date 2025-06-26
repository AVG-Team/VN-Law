export const TreeLawActionTypes = {
    FETCH_TOPICS_REQUEST: "FETCH_TOPICS_REQUEST",
    FETCH_TOPICS_SUCCESS: "FETCH_TOPICS_SUCCESS",
    FETCH_TOPICS_FAILURE: "FETCH_TOPICS_FAILURE",

    FETCH_ARTICLE_TREE_REQUEST: "FETCH_ARTICLE_TREE_REQUEST",
    FETCH_ARTICLE_TREE_SUCCESS: "FETCH_ARTICLE_TREE_SUCCESS",
    FETCH_ARTICLE_TREE_FAILURE: "FETCH_ARTICLE_TREE_FAILURE",

    FETCH_CHAPTER_DATA_REQUEST: "FETCH_CHAPTER_DATA_REQUEST",
    FETCH_CHAPTER_DATA_SUCCESS: "FETCH_CHAPTER_DATA_SUCCESS",
    FETCH_CHAPTER_DATA_FAILURE: "FETCH_CHAPTER_DATA_FAILURE",

    LOAD_TREE_DATA_REQUEST: "LOAD_TREE_DATA_REQUEST",
    LOAD_TREE_DATA_SUCCESS: "LOAD_TREE_DATA_SUCCESS",
    LOAD_TREE_DATA_FAILURE: "LOAD_TREE_DATA_FAILURE",

    SET_EXPANDED_KEYS: "SET_EXPANDED_KEYS",
    SET_SELECTED_KEYS: "SET_SELECTED_KEYS",
    SET_CHAPTER_SELECTED: "SET_CHAPTER_SELECTED",

    UPDATE_CHAPTER_ARTICLES: "UPDATE_CHAPTER_ARTICLES",
};

export const fetchTopicsRequest = () => ({ type: TreeLawActionTypes.FETCH_TOPICS_REQUEST });
export const fetchTopicsSuccess = (data) => ({ type: TreeLawActionTypes.FETCH_TOPICS_SUCCESS, payload: data });
export const fetchTopicsFailure = (error) => ({ type: TreeLawActionTypes.FETCH_TOPICS_FAILURE, payload: error });

export const fetchArticleTreeRequest = (articleId) => ({
    type: TreeLawActionTypes.FETCH_ARTICLE_TREE_REQUEST,
    payload: articleId,
});
export const fetchArticleTreeSuccess = (data) => ({
    type: TreeLawActionTypes.FETCH_ARTICLE_TREE_SUCCESS,
    payload: data,
});
export const fetchArticleTreeFailure = (error) => ({
    type: TreeLawActionTypes.FETCH_ARTICLE_TREE_FAILURE,
    payload: error,
});

export const fetchChapterDataRequest = (chapterId) => ({
    type: TreeLawActionTypes.FETCH_CHAPTER_DATA_REQUEST,
    payload: chapterId,
});
export const fetchChapterDataSuccess = (data) => ({
    type: TreeLawActionTypes.FETCH_CHAPTER_DATA_SUCCESS,
    payload: data,
});
export const fetchChapterDataFailure = (error) => ({
    type: TreeLawActionTypes.FETCH_CHAPTER_DATA_FAILURE,
    payload: error,
});

export const loadTreeDataRequest = (key, name) => ({
    type: TreeLawActionTypes.LOAD_TREE_DATA_REQUEST,
    payload: { key, name },
});
export const loadTreeDataSuccess = (data) => ({ type: TreeLawActionTypes.LOAD_TREE_DATA_SUCCESS, payload: data });
export const loadTreeDataFailure = (error) => ({ type: TreeLawActionTypes.LOAD_TREE_DATA_FAILURE, payload: error });

export const setExpandedKeys = (keys) => ({ type: TreeLawActionTypes.SET_EXPANDED_KEYS, payload: keys });
export const setSelectedKeys = (keys) => ({ type: TreeLawActionTypes.SET_SELECTED_KEYS, payload: keys });
export const setChapterSelected = (chapter) => ({ type: TreeLawActionTypes.SET_CHAPTER_SELECTED, payload: chapter });
export const updateChapterArticles = (articles) => ({
    type: TreeLawActionTypes.UPDATE_CHAPTER_ARTICLES,
    payload: articles,
});
