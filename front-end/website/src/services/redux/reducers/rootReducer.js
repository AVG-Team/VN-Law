import { combineReducers } from "redux";
import topicReducer from "./topicReducer";
import articleReducer from "./articleReducer";
import chapterReducer from "./chapterReducer";
import subjectReducer from "./subjectReducer";
import vbqpplReducer from "./vbqpplReducer";
import treeLawReducer from "./treeLawReducer";

const rootReducer = combineReducers({
    topic: topicReducer,
    article: articleReducer,
    chapter: chapterReducer,
    subject: subjectReducer,
    vbqppl: vbqpplReducer,
    treelaw: treeLawReducer,
});

export default rootReducer;
