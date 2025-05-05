import { all } from "redux-saga/effects";
import vbqpplSaga from "./vbqpplSaga";

export default function* rootSaga() {
    yield all([
        vbqpplSaga(),
        articleSaga(),
        subjectSaga(),
        topicSaga(),
        tableSaga(),
        chapterSaga(),
        // Add other sagas here as needed
        // e.g., yield all([otherSaga1(), otherSaga2()]),
    ]);
}
