import { all } from "redux-saga/effects";
import vbqpplSaga from "./vbqpplSaga";
import articleSaga from "./articleSaga";
import subjectSaga from "./subjectSaga";
import topicSaga from "./topicSaga";
import tableSaga from "./tableSaga";
import chapterSaga from "./chapterSaga";
import treeLawSaga from "./treeLawSaga"; // Assuming you have a treeLawSaga to handle tree-related actions

export default function* rootSaga() {
    yield all([
        vbqpplSaga(),
        articleSaga(),
        subjectSaga(),
        topicSaga(),
        tableSaga(),
        chapterSaga(),
        treeLawSaga(), // Assuming you have a treeLawSaga to handle tree-related actions
        // Add other sagas here as needed
        // e.g., yield all([otherSaga1(), otherSaga2()]),
    ]);
}
