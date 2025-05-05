import { ChapterActionTypes } from "../actions/chapterAction";

const initialState = {
    chapters: [], // Danh sách tất cả các chương
    chapter: null, // Chi tiết một chương
    loading: false, // Trạng thái đang tải
    error: null, // Lỗi nếu có
};

const chapterReducer = (state = initialState, action) => {
    switch (action.type) {
        // Xử lý khi lấy danh sách tất cả các chương
        case ChapterActionTypes.GET_ALL_BY_PAGE_REQUEST:
            return { ...state, loading: true, error: null };
        case ChapterActionTypes.GET_ALL_BY_PAGE_SUCCESS:
            return { ...state, loading: false, chapters: action.payload };
        case ChapterActionTypes.GET_ALL_BY_PAGE_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy chi tiết một chương
        case ChapterActionTypes.GET_BY_ID_REQUEST:
            return { ...state, loading: true, error: null };
        case ChapterActionTypes.GET_BY_ID_SUCCESS:
            return { ...state, loading: false, chapter: action.payload };
        case ChapterActionTypes.GET_BY_ID_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy danh sách chương theo mục
        case ChapterActionTypes.GET_BY_SUBJECT_REQUEST:
            return { ...state, loading: true, error: null };
        case ChapterActionTypes.GET_BY_SUBJECT_SUCCESS:
            return { ...state, loading: false, chapters: action.payload };
        case ChapterActionTypes.GET_BY_SUBJECT_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy danh sách tất cả các chương
        case ChapterActionTypes.GET_ALL_REQUEST:
            return { ...state, loading: true, error: null };
        case ChapterActionTypes.GET_ALL_SUCCESS:
            return { ...state, loading: false, chapters: action.payload };
        case ChapterActionTypes.GET_ALL_FAILURE:
            return { ...state, loading: false, error: action.payload };

        default:
            return state;
    }
};

export default chapterReducer;
