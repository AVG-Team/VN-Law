import { useRef, useState, useEffect, useCallback } from "react";
import SockJS from "sockjs-client";
import { Client } from "@stomp/stompjs";
import { v4 as uuidv4 } from "uuid";

const useWebSocketChat = (baseUrl, onMessageReceived) => {
    const socketRef = useRef(null);
    const messageQueueRef = useRef([]);
    const reconnectTimeoutRef = useRef(null);
    const subscriptionsRef = useRef([]);

    const [connectionStatus, setConnectionStatus] = useState("disconnected");
    const [pendingMessages, setPendingMessages] = useState(new Set());

    const MAX_RECONNECT_ATTEMPTS = 5;
    const RECONNECT_INTERVAL = 3000;
    const MESSAGE_TIMEOUT = 30000;

    // Initialize WebSocket connection with retry mechanism
    const initializeWebSocket = useCallback(() => {
        if (socketRef.current?.active) return;

        const socket = new Client({
            webSocketFactory: () => new SockJS(baseUrl + "/socket-service/ws"),
            debug: (str) => {
                console.debug(str);
            },
            reconnectDelay: 5000,
            heartbeatIncoming: 4000,
            heartbeatOutgoing: 4000,
        });

        socket.onConnect = () => {
            console.log("WebSocket Connected");
            setConnectionStatus("connected");
            subscribeToTopics();
            processMessageQueue();
        };

        socket.onStompError = (frame) => {
            console.error("STOMP error", frame);
            setConnectionStatus("error");
        };

        socket.onWebSocketClose = () => {
            console.log("WebSocket Connection Closed");
            setConnectionStatus("disconnected");
            handleReconnect();
        };

        socket.activate();
        socketRef.current = socket;
    }, [baseUrl]);

    // Subscribe to WebSocket topics
    const subscribeToTopics = useCallback(() => {
        if (!socketRef.current?.active) return;

        const publicSubscription = socketRef.current.subscribe("/server/public", (message) => {
            console.log("Public message received:", message.body);
        });

        const dataSubscription = socketRef.current.subscribe("/server/sendData", (message) => {
            try {
                const messageId = message.headers["message-id"];
                const parsedResponse = JSON.parse(message.body);
                const answer = parsedResponse.answer.fullAnswer;

                if (messageId && pendingMessages.has(messageId)) {
                    pendingMessages.delete(messageId);
                    setPendingMessages(new Set(pendingMessages));
                }

                if (onMessageReceived) {
                    onMessageReceived(answer);
                }
            } catch (error) {
                console.error("Error processing message:", error);
            }
        });

        subscriptionsRef.current = [publicSubscription, dataSubscription];
    }, []);

    // Handle reconnection
    const handleReconnect = useCallback(() => {
        let reconnectAttempts = 0;

        const attemptReconnect = () => {
            if (reconnectAttempts >= MAX_RECONNECT_ATTEMPTS) {
                console.error("Max reconnection attempts reached");
                setConnectionStatus("failed");
                return;
            }

            reconnectAttempts++;
            console.log(`Reconnection attempt ${reconnectAttempts}`);
            initializeWebSocket();
        };

        reconnectTimeoutRef.current = setTimeout(attemptReconnect, RECONNECT_INTERVAL);
    }, [initializeWebSocket]);

    // Process message queue
    const processMessageQueue = useCallback(() => {
        if (!socketRef.current?.active) return;

        while (messageQueueRef.current.length > 0) {
            const { content, messageId } = messageQueueRef.current.shift();
            sendMessageToServer(content, messageId);
        }
    }, []);

    // Send message with timeout and retry
    const sendMessageToServer = useCallback(
        (content, messageId) => {
            if (!socketRef.current?.active) {
                messageQueueRef.current.push({ content, messageId });
                initializeWebSocket();
                return;
            }

            const headers = {
                "message-id": messageId,
                "content-type": "application/json",
            };

            try {
                socketRef.current.publish({
                    destination: "/web/sendMessage",
                    headers,
                    body: JSON.stringify({ content, messageId }),
                });

                // Set timeout for message
                setTimeout(() => {
                    if (pendingMessages.has(messageId)) {
                        pendingMessages.delete(messageId);
                        setPendingMessages(new Set(pendingMessages));
                        console.warn(`Message ${messageId} timed out`);
                    }
                }, MESSAGE_TIMEOUT);
            } catch (error) {
                console.error("Error sending message:", error);
                messageQueueRef.current.push({ content, messageId });
            }
        },
        [initializeWebSocket],
    );

    // Public send message function
    const sendMessage = useCallback(
        (content) => {
            if (!content.trim()) return;

            const messageId = uuidv4();
            setPendingMessages((prev) => new Set(prev).add(messageId));

            sendMessageToServer(content.trim(), messageId);

            return messageId;
        },
        [sendMessageToServer],
    );

    // Cleanup function
    useEffect(() => {
        initializeWebSocket();

        return () => {
            if (reconnectTimeoutRef.current) {
                clearTimeout(reconnectTimeoutRef.current);
            }

            subscriptionsRef.current.forEach((subscription) => {
                try {
                    subscription.unsubscribe();
                } catch (error) {
                    console.error("Error unsubscribing:", error);
                }
            });

            if (socketRef.current?.active) {
                socketRef.current.deactivate();
            }
        };
    }, [initializeWebSocket]);

    return {
        sendMessage,
        connectionStatus,
        pendingMessages: pendingMessages.size,
        hasQueuedMessages: messageQueueRef.current.length > 0,
    };
};

export default useWebSocketChat;
