import { Card, Spin } from "antd";
import { motion, AnimatePresence } from "framer-motion";
import { useAutoAnimate } from "@formkit/auto-animate/react";
import { useState, useRef, useEffect } from "react";
import PropTypes from "prop-types";

import ChatHeader from "./components/ChatHeader";
import ChatMessage from "./components/ChatMessage";
import ChatInput from "./components/ChatInput";
import ChatSidebar from "./components/ChatSidebar";
import { STORAGE_KEY, MAX_HISTORY_ITEMS, processResponse, sampleResponses } from "./utils/chatUtils";

const Chatbot = () => {
    const [messages, setMessages] = useState([]);
    const [inputMessage, setInputMessage] = useState("");
    const [loading, setLoading] = useState(false);
    const [copiedMessageId, setCopiedMessageId] = useState(null);
    const [chatHistory, setChatHistory] = useState([]);
    const [collapsed, setCollapsed] = useState(false);
    const [currentChatId, setCurrentChatId] = useState(null);
    const messagesEndRef = useRef(null);
    const [parent] = useAutoAnimate();

    // Load chat history on component mount
    useEffect(() => {
        const savedHistory = localStorage.getItem(STORAGE_KEY);
        if (savedHistory) {
            try {
                const parsedHistory = JSON.parse(savedHistory);
                setChatHistory(parsedHistory);
            } catch (error) {
                console.error("Error loading chat history:", error);
            }
        }
    }, []);

    // Save messages to history when they change
    useEffect(() => {
        if (messages.length > 0) {
            const newHistory = {
                id: currentChatId || Date.now(),
                title: messages[0].text.slice(0, 50) + (messages[0].text.length > 50 ? "..." : ""),
                messages: messages,
                timestamp: new Date(),
            };

            setChatHistory((prev) => {
                const updated = [newHistory, ...prev.filter((item) => item.id !== currentChatId)].slice(
                    0,
                    MAX_HISTORY_ITEMS,
                );
                localStorage.setItem(STORAGE_KEY, JSON.stringify(updated));
                return updated;
            });
        }
    }, [messages, currentChatId]);

    const scrollToBottom = () => {
        messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
    };

    useEffect(() => {
        scrollToBottom();
    }, [messages]);

    const handleSend = async () => {
        if (!inputMessage.trim() || loading) return;

        const userMessage = {
            id: Date.now(),
            text: inputMessage.trim(),
            sender: "user",
            timestamp: new Date(),
        };

        setMessages((prev) => [...prev, userMessage]);
        setInputMessage("");
        setLoading(true);

        try {
            // Simulate API delay
            await new Promise((resolve) => setTimeout(resolve, 1000));
            const response = processResponse(inputMessage);

            const botMessage = {
                id: Date.now() + 1,
                text: response,
                sender: "bot",
                timestamp: new Date(),
            };

            setMessages((prev) => [...prev, botMessage]);
        } catch (error) {
            const errorMessage = {
                id: Date.now() + 1,
                text: sampleResponses.error,
                sender: "bot",
                timestamp: new Date(),
            };
            setMessages((prev) => [...prev, errorMessage]);
        } finally {
            setLoading(false);
        }
    };

    const handleNewChat = () => {
        setMessages([]);
        setCurrentChatId(null);
    };

    const handleLoadHistory = (historyItem) => {
        setMessages(historyItem.messages);
        setCurrentChatId(historyItem.id);
        if (window.innerWidth < 768) {
            setCollapsed(true);
        }
    };

    const handleDeleteHistory = (historyId) => {
        setChatHistory((prev) => {
            const updated = prev.filter((item) => item.id !== historyId);
            localStorage.setItem(STORAGE_KEY, JSON.stringify(updated));
            if (historyId === currentChatId) {
                setMessages([]);
                setCurrentChatId(null);
            }
            return updated;
        });
    };

    const handleCopyMessage = async (messageId) => {
        const message = messages.find((m) => m.id === messageId);
        if (message) {
            await navigator.clipboard.writeText(message.text);
            setCopiedMessageId(messageId);
            setTimeout(() => setCopiedMessageId(null), 2000);
        }
    };

    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="h-[calc(100vh-64px)] flex bg-gray-50"
        >
            <ChatSidebar
                collapsed={collapsed}
                chatHistory={chatHistory}
                currentChatId={currentChatId}
                onNewChat={handleNewChat}
                onLoadHistory={handleLoadHistory}
                onDeleteHistory={handleDeleteHistory}
            />

            <div className="flex flex-col flex-1 h-full">
                <Card className="flex flex-col h-full border-none shadow-none">
                    <ChatHeader collapsed={collapsed} onToggleCollapse={() => setCollapsed(!collapsed)} />

                    <div ref={parent} className="flex-1 px-6 space-y-6 overflow-y-auto">
                        <AnimatePresence>
                            {messages.map((message, index) => (
                                <ChatMessage
                                    key={message.id}
                                    message={message}
                                    onCopy={handleCopyMessage}
                                    copiedMessageId={copiedMessageId}
                                />
                            ))}
                        </AnimatePresence>
                        {loading && (
                            <motion.div
                                initial={{ opacity: 0, y: 20 }}
                                animate={{ opacity: 1, y: 0 }}
                                exit={{ opacity: 0, y: -20 }}
                                className="flex justify-start"
                            >
                                <div className="p-4 bg-white shadow-sm rounded-2xl">
                                    <Spin />
                                </div>
                            </motion.div>
                        )}
                        <div ref={messagesEndRef} />
                    </div>

                    <ChatInput
                        value={inputMessage}
                        onChange={(e) => setInputMessage(e.target.value)}
                        onSend={handleSend}
                        loading={loading}
                    />
                </Card>
            </div>
        </motion.div>
    );
};

Chatbot.propTypes = {
    element: PropTypes.element,
};

export default Chatbot;
