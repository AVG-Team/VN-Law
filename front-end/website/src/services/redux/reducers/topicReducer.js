import { TopicActionTypes } from "../actions/topicAction";

const initialState = {
    topics: [], // Danh sách tất cả các chủ đề
    topic: null, // Chi tiết một chủ đề
    loading: false, // Trạng thái đang tải
    error: null, // Lỗi nếu có
};

const topicReducer = (state = initialState, action) => {
    switch (action.type) {
        // Xử lý khi lấy danh sách tất cả các chủ đề
        case TopicActionTypes.GET_ALL_REQUEST:
            return { ...state, loading: true, error: null };
        case TopicActionTypes.GET_ALL_SUCCESS:
            return { ...state, loading: false, topics: action.payload };
        case TopicActionTypes.GET_ALL_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy chi tiết một chủ đề
        case TopicActionTypes.GET_BY_ID_REQUEST:
            return { ...state, loading: true, error: null };
        case TopicActionTypes.GET_BY_ID_SUCCESS:
            return { ...state, loading: false, topic: action.payload };
        case TopicActionTypes.GET_BY_ID_FAILURE:
            return { ...state, loading: false, error: action.payload };

        default:
            return state;
    }
};

export default topicReducer;
