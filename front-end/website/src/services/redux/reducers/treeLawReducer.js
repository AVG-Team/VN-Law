import { TreeLawActionTypes } from "../actions/treeLawAction";

const initialState = {
    treeData: [],
    loading: false,
    error: null,
    expandedKeys: [],
    selectedKeys: [],
    chapterSelected: null,
};

const treeLawReducer = (state = initialState, action) => {
    switch (action.type) {
        case TreeLawActionTypes.FETCH_TOPICS_SUCCESS:
            return { ...state, treeData: action.payload, loading: false };
        case TreeLawActionTypes.FETCH_TOPICS_FAILURE:
            return { ...state, error: action.payload, loading: false };
        case TreeLawActionTypes.FETCH_ARTICLE_TREE_SUCCESS:
            return {
                ...state,
                treeData: action.payload.treeData,
                expandedKeys: action.payload.expandedKeys,
                selectedKeys: action.payload.selectedKeys,
                loading: false,
            };

        case TreeLawActionTypes.FETCH_ARTICLE_TREE_FAILURE:
            return { ...state, error: action.payload, loading: false };
        case TreeLawActionTypes.FETCH_CHAPTER_DATA_SUCCESS:
            return { ...state, chapterSelected: action.payload, loading: false };
        case TreeLawActionTypes.FETCH_CHAPTER_DATA_FAILURE:
            return { ...state, error: action.payload, loading: false };

        case TreeLawActionTypes.LOAD_TREE_DATA_SUCCESS:
            return { ...state, treeData: action.payload, loading: false };
        case TreeLawActionTypes.LOAD_TREE_DATA_FAILURE:
            return { ...state, error: action.payload, loading: false };

        case TreeLawActionTypes.SET_EXPANDED_KEYS:
            return { ...state, expandedKeys: action.payload };
        case TreeLawActionTypes.SET_SELECTED_KEYS:
            return { ...state, selectedKeys: action.payload };
        case TreeLawActionTypes.SET_CHAPTER_SELECTED:
            return { ...state, chapterSelected: action.payload };
        case TreeLawActionTypes.UPDATE_CHAPTER_ARTICLES:
            return {
                ...state,
                chapterSelected: {
                    ...state.chapterSelected,
                    articles: [...(state.chapterSelected?.articles || []), ...action.payload],
                },
            };
        default:
            return state;
    }
};

export default treeLawReducer;
