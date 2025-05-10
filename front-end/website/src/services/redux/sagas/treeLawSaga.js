import { call, put, takeLatest, select } from "redux-saga/effects";
import { TreeLawActionTypes } from "../actions/treeLawAction";
import { getAllSaga } from "~/services/redux/sagas/topicSaga";
import { getByChapterIdSaga, getTreeArticleSaga } from "~/services/redux/sagas/articleSaga";
import { getByTopicSaga } from "~/services/redux/sagas/subjectSaga";
import { getBySubjectSaga } from "~/services/redux/sagas/chapterSaga";

const updateTreeData = (list, key, children) =>
    list.map((node) => {
        if (node.key === key) {
            return { ...node, children };
        }
        if (node.children) {
            return { ...node, children: updateTreeData(node.children, key, children) };
        }
        return node;
    });

function* fetchTopicsSaga() {
    try {
        const topicList = yield call(getAllSaga);
        console.log("getAllSagal response:", topicList);
        const data = topicList.data.map((topic) => ({
            title: `Chủ đề ${topic.order}: ${topic.name}`,
            key: `topic_${topic.id.toString()}`,
            children: undefined,
            icon: "folder",
            name: topic.name, // Thêm thuộc tính name
        }));
        yield put({ type: TreeLawActionTypes.FETCH_TOPICS_SUCCESS, payload: data });
    } catch (error) {
        console.error("Error in fetchTopicsSaga:", error);
        yield put({ type: TreeLawActionTypes.FETCH_TOPICS_FAILURE, payload: error.message });
    }
}
function* fetchArticleTreeSaga(action) {
    try {
        console.log("Fetching article tree for articleId:", action.payload);
        const topicList = yield call(getAllSaga);
        console.log("topicApi.getAll response:", topicList);
        const initialData = topicList.data.map((topic) => ({
            title: `Chủ đề ${topic.order}: ${topic.name}`,
            key: `topic_${topic.id.toString()}`,
            children: undefined,
            icon: "folder",
            name: topic.name, // Thêm thuộc tính name
        }));

        yield put({ type: TreeLawActionTypes.FETCH_TOPICS_SUCCESS, payload: initialData });

        const response = yield call(getTreeArticleSaga, action.payload);
        console.log("articleApi.getTreeArticle response:", response);
        const { topic, subject, chapter, articles } = response.data;
        const keyChapter = `chapter_${chapter.id}`;
        const keySubject = `subject_${subject.id}`;
        const keyTopic = `topic_${topic.id}`;

        yield put({
            type: TreeLawActionTypes.SET_CHAPTER_SELECTED,
            payload: { id: chapter.id, name: chapter.name, articles },
        });
        yield put({ type: TreeLawActionTypes.SET_EXPANDED_KEYS, payload: [keyTopic, keySubject, keyChapter] });
        yield put({ type: TreeLawActionTypes.SET_SELECTED_KEYS, payload: [keyChapter] });

        const updatedData = yield call(loadDataSaga, { key: keyTopic, name: topic.name });
        yield call(loadDataSaga, { key: keySubject, name: subject.name });

        yield put({
            type: TreeLawActionTypes.FETCH_ARTICLE_TREE_SUCCESS,
            payload: {
                treeData: updatedData,
                expandedKeys: [keyTopic, keySubject, keyChapter],
                selectedKeys: [keyChapter],
            },
        });
    } catch (error) {
        console.error("Error in fetchArticleTreeSaga:", error);
        yield put({ type: TreeLawActionTypes.FETCH_ARTICLE_TREE_FAILURE, payload: error.message });
    }
}

function* fetchChapterDataSaga(action) {
    try {
        const res = yield call(getByChapterIdSaga, action.payload);
        console.log("articleApi.getByChapterId response:", res);
        yield put({
            type: TreeLawActionTypes.FETCH_CHAPTER_DATA_SUCCESS,
            payload: {
                id: action.payload,
                name: res.data.name || `Chapter ${action.payload}`,
                articles: res.data.content || [],
            },
        });
    } catch (error) {
        console.error("Error in fetchChapterDataSaga:", error);
        yield put({ type: TreeLawActionTypes.FETCH_CHAPTER_DATA_FAILURE, payload: error.message });
    }
}

function* loadDataSaga(action) {
    try {
        let data = [];
        if (action.payload.key.startsWith("topic")) {
            const topicId = action.payload.key.split("_")[1];
            const subjects = yield call(getByTopicSaga, topicId);
            console.log("subjectApi.getByTopic response for topicId", topicId, ":", subjects);
            data = subjects.data.map((subject) => ({
                title: `Đề mục ${subject.order}: ${subject.name}`,
                key: `subject_${subject.id.toString()}`,
                name: subject.name, // Thêm thuộc tính name
                children: undefined,
                icon: "folder",
            }));
        } else if (action.payload.key.startsWith("subject")) {
            const subjectId = action.payload.key.split("_")[1];
            const chapters = yield call(getBySubjectSaga, subjectId);
            console.log("chapterApi.getBySubject response for subjectId", subjectId, ":", chapters);
            data = chapters.data.map((chapter) => ({
                title: `${chapter.name}`,
                key: `chapter_${chapter.id.toString()}`,
                name: chapter.name, // Thêm thuộc tính name
                children: undefined,
                isLeaf: true,
                icon: "file",
            }));
        }

        const currentTreeData = yield select((state) => state.treelaw.treeData);
        let updatedTreeData = currentTreeData;

        if (currentTreeData.length === 0 && action.payload.key.startsWith("topic")) {
            updatedTreeData = [
                {
                    title: `Chủ đề: ${action.payload.name || "Chưa có tên"}`,
                    key: action.payload.key,
                    name: action.payload.name, // Thêm thuộc tính name
                    children: data,
                    icon: "folder",
                },
            ];
        } else {
            updatedTreeData = updateTreeData(currentTreeData, action.payload.key, data);
        }

        console.log("Updated treeData:", updatedTreeData);
        yield put({
            type: TreeLawActionTypes.LOAD_TREE_DATA_SUCCESS,
            payload: updatedTreeData,
        });
    } catch (error) {
        console.error("Error in loadDataSaga:", error);
        yield put({ type: TreeLawActionTypes.LOAD_TREE_DATA_FAILURE, payload: error.message });
    }
}

export default function* treeLawSaga() {
    yield takeLatest(TreeLawActionTypes.FETCH_TOPICS_REQUEST, fetchTopicsSaga);
    yield takeLatest(TreeLawActionTypes.FETCH_ARTICLE_TREE_REQUEST, fetchArticleTreeSaga);
    yield takeLatest(TreeLawActionTypes.FETCH_CHAPTER_DATA_REQUEST, fetchChapterDataSaga);
    yield takeLatest(TreeLawActionTypes.LOAD_TREE_DATA_REQUEST, loadDataSaga);
}
