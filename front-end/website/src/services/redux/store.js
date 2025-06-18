import { legacy_createStore as createStore, applyMiddleware } from "redux";
import createSagaMiddleware from "redux-saga";
import rootReducer from "./reducers/rootReducer"; // Import rootReducer
import rootSaga from "./sagas/rootSaga"; // Import rootSaga

// Tạo saga middleware
const sagaMiddleware = createSagaMiddleware();

// Tạo Redux store
const store = createStore(rootReducer, applyMiddleware(sagaMiddleware));

// Chạy saga middleware
sagaMiddleware.run(rootSaga);

export default store;
