import { ArticleActionTypes } from "../actions/articleAction";

const initialState = {
    articles: [], // Danh sách tất cả các bài viết
    article: null, // Chi tiết một bài viết
    loading: false, // Trạng thái đang tải
    error: null, // Lỗi nếu có
};

const articleReducer = (state = initialState, action) => {
    switch (action.type) {
        // Xử lý khi lấy danh sách tất cả các bài viết
        case ArticleActionTypes.GET_ALL_BY_PAGE_REQUEST:
            return { ...state, loading: true, error: null };
        case ArticleActionTypes.GET_ALL_BY_PAGE_SUCCESS:
            return { ...state, loading: false, articles: action.payload };
        case ArticleActionTypes.GET_ALL_BY_PAGE_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy chi tiết một bài viết
        case ArticleActionTypes.GET_BY_CHAPTER_ID_REQUEST:
            return { ...state, loading: true, error: null };
        case ArticleActionTypes.GET_BY_CHAPTER_ID_SUCCESS:
            return { ...state, loading: false, article: action.payload };
        case ArticleActionTypes.GET_BY_CHAPTER_ID_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // xử lý khi lấy cây bài viết
        case ArticleActionTypes.GET_TREE_ARTICLE_REQUEST:
            return { ...state, loading: true, error: null };
        case ArticleActionTypes.GET_TREE_ARTICLE_SUCCESS:
            return { ...state, loading: false, article: action.payload };
        case ArticleActionTypes.GET_TREE_ARTICLE_FAILURE:
            return { ...state, loading: false, error: action.payload };

        default:
            return state;
    }
};

export default articleReducer;
