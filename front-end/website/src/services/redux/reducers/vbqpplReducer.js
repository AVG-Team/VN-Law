import { VbqpplActionTypes } from "../actions/vbqpplAction";

const initialState = {
    vbqppls: [], // Danh sách tất cả các văn bản quy phạm pháp luật
    vbqppl: null, // Chi tiết một văn bản
    loading: false, // Trạng thái đang tải
    error: null, // Lỗi nếu có
};

const vbqpplReducer = (state = initialState, action) => {
    switch (action.type) {
        // Xử lý khi lấy danh sách tất cả các văn bản
        case VbqpplActionTypes.GET_ALL_BY_PAGE_REQUEST:
            return { ...state, loading: true, error: null };
        case VbqpplActionTypes.GET_ALL_BY_PAGE_SUCCESS:
            return { ...state, loading: false, vbqppls: action.payload };
        case VbqpplActionTypes.GET_ALL_BY_PAGE_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy chi tiết một văn bản
        case VbqpplActionTypes.GET_BY_ID_REQUEST:
            return { ...state, loading: true, error: null };
        case VbqpplActionTypes.GET_BY_ID_SUCCESS:
            return { ...state, loading: false, vbqppl: action.payload };
        case VbqpplActionTypes.GET_BY_ID_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy danh sách tất cả các văn bản
        case VbqpplActionTypes.GET_ALL_REQUEST:
            return { ...state, loading: true, error: null };
        case VbqpplActionTypes.GET_ALL_SUCCESS:
            return { ...state, loading: false, vbqppls: action.payload };
        case VbqpplActionTypes.GET_ALL_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy danh sách văn bản theo filter
        case VbqpplActionTypes.FILTER_REQUEST:
            return { ...state, loading: true, error: null };
        case VbqpplActionTypes.FILTER_SUCCESS:
            return { ...state, loading: false, vbqppls: action.payload };
        case VbqpplActionTypes.FILTER_FAILURE:
            return { ...state, loading: false, error: action.payload };

        default:
            return state;
    }
};

export default vbqpplReducer;
