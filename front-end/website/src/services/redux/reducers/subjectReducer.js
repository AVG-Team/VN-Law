import { SubjectActionTypes } from "../actions/subjectAction";

const initialState = {
    subjects: [], // Danh sách tất cả các môn học
    subject: null, // Chi tiết một môn học
    loading: false, // Trạng thái đang tải
    error: null, // Lỗi nếu có
};

const subjectReducer = (state = initialState, action) => {
    switch (action.type) {
        // Xử lý khi lấy danh sách tất cả các môn học
        case SubjectActionTypes.GET_ALL_SUBJECTS_BY_PAGE_REQUEST:
            return { ...state, loading: true, error: null };
        case SubjectActionTypes.GET_ALL_SUBJECTS_BY_PAGE_SUCCESS:
            return { ...state, loading: false, subjects: action.payload };
        case SubjectActionTypes.GET_ALL_SUBJECTS_BY_PAGE_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy chi tiết một môn học
        case SubjectActionTypes.GET_BY_SUBJECT_ID_REQUEST:
            return { ...state, loading: true, error: null };
        case SubjectActionTypes.GET_BY_SUBJECT_ID_SUCCESS:
            return { ...state, loading: false, subject: action.payload };
        case SubjectActionTypes.GET_BY_SUBJECT_ID_FAILURE:
            return { ...state, loading: false, error: action.payload };

        // Xử lý khi lấy danh sách môn học theo chủ đề
        case SubjectActionTypes.GET_BY_TOPIC_REQUEST:
            return { ...state, loading: true, error: null };
        case SubjectActionTypes.GET_BY_TOPIC_SUCCESS:
            return { ...state, loading: false, subjects: action.payload };
        case SubjectActionTypes.GET_BY_TOPIC_FAILURE:
            return { ...state, loading: false, error: action.payload };

        default:
            return state;
    }
};

export default subjectReducer;
