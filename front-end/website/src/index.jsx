import React from "react";
import ReactDOM from "react-dom/client";
import App from "~/App";
import "./styles.css";
import { Provider } from "react-redux";
import store from "./services/redux/store"; // Import the store

ReactDOM.createRoot(document.getElementById("root")).render(
    <React.StrictMode>
        <Provider store={store}>
            <App />
        </Provider>
    </React.StrictMode>,
);
