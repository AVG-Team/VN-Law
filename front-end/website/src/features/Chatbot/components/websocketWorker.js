// websocketWorker.js
import SockJS from "sockjs-client";
import Stomp from "stompjs";

let stompClient = null;

this.onmessage = (event) => {
    const { type, payload } = event.data;

    if (type === "CONNECT") {
        const baseUrl = payload.baseUrl;
        const socket = new SockJS(`${baseUrl}/socket-service/ws`);
        stompClient = Stomp.over(socket);
        stompClient.debug = null;

        stompClient.connect(
            {},
            () => {
                this.postMessage({ type: "CONNECTED" });
                stompClient.subscribe("/server/sendData", (response) => {
                    const parsedResponse = JSON.parse(response.body);
                    this.postMessage({ type: "MESSAGE", payload: parsedResponse });
                });
            },
            (error) => {
                this.postMessage({ type: "ERROR", payload: error });
            },
        );
    }

    if (type === "SEND_MESSAGE" && stompClient && stompClient.connected) {
        stompClient.send("/web/sendMessage", {}, payload);
    }
};
