import { useRef, useEffect, useState } from "react";
import { Send, Scale, User, Bot, Paperclip, Menu, Home } from "lucide-react";
import ChatSidebar from "./components/ChatSidebar";
import { useNavigate } from "react-router-dom";
import Logo from "~/assets/images/logo/logo.png";
import { useDispatch, useSelector } from "react-redux";
import {
    sendMessageRequest,
    getChatHistoryRequest,
    getChatByIdRequest,
    createConversationRequest,
    deleteConversationRequest,
    clearChat,
    addMessage,
} from "~/services/redux/actions/chatAction";
import { notification } from "antd";

export default function LegalAIChatbot() {
    const navigate = useNavigate();
    const dispatch = useDispatch();
    const { messages, isTyping, chatHistory, conversationId, loading, error } = useSelector((state) => state.chatbot);
    const [inputMessage, setInputMessage] = useState("");
    const [sidebarOpen, setSidebarOpen] = useState(true);
    const [pendingMessage, setPendingMessage] = useState(null);
    const [conversationHistory, setConversationHistory] = useState([]);
    const messagesEndRef = useRef(null);
    const inputRef = useRef(null);

    useEffect(() => {
        dispatch(getChatHistoryRequest());

        const style = document.createElement("style");
        style.textContent = `
      @keyframes typing-dot {
        0%, 60%, 100% { transform: translateY(0); opacity: 0.4; }
        30% { transform: translateY(-10px); opacity: 1; }
      }
      @keyframes fade-in {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
      }
      @keyframes scale-in {
        from { transform: scale(0.95); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
      }
      @keyframes wave {
        0%, 100% { transform: scaleX(1); }
        50% { transform: scaleX(1.1); }
      }
      .animate-typing-dot { animation: typing-dot 1.4s infinite ease-in-out; }
      .animate-fade-in { animation: fade-in 0.3s ease-out; }
      .animate-scale-in { animation: scale-in 0.2s ease-out; }
      .animate-wave { animation: wave 2s infinite ease-in-out; }
    `;
        document.head.appendChild(style);

        return () => {
            document.head.removeChild(style);
        };
    }, [dispatch]);

    useEffect(() => {
        if (error) {
            notification.error({
                message: "Lỗi",
                description: error,
            });
        }
    }, [error]);

    const handleSendMessage = () => {
        if (!inputMessage.trim()) return;

        const userMessage = inputMessage.trim();

        // Tạo pending message để hiển thị tạm thời
        const newUserMessage = {
            id: "pending-" + Date.now(),
            type: "user",
            context: userMessage,
            timestamp: new Date().toISOString(),
        };

        // Set pending message
        setPendingMessage(newUserMessage);

        // Xóa input
        setInputMessage("");

        // Gửi request API
        dispatch(sendMessageRequest(userMessage, conversationId));
    };

    const handleKeyPress = (e) => {
        if (e.key === "Enter" && !e.shiftKey) {
            e.preventDefault();
            handleSendMessage();
        }
    };

    const handleNewChat = () => {
        console.log("Starting new chat...");
        dispatch(clearChat());
    };

    const handleChatSelect = (chatId) => {
        dispatch(getChatByIdRequest(chatId));
    };

    const handleDelete = (historyId) => {
        // dispatch(deleteConversationRequest(historyId));
    };

    const formatTime = (date) => {
        return new Date(date).toLocaleTimeString("vi-VN", {
            hour: "2-digit",
            minute: "2-digit",
        });
    };

    const addFirstMessage = () => {
        console.log("Adding welcome message...");
        const welcomeMessage = {
            id: "welcome-" + Date.now(),
            type: "bot",
            content:
                "Chào mừng bạn đến với LegalWise – người bạn đồng hành pháp lý của bạn! Hãy đặt câu hỏi, chúng tôi sẽ giúp bạn giải đáp dựa trên dữ liệu pháp luật Việt Nam cập nhật",
            timestamp: new Date().toISOString(),
        };
        messages.push(welcomeMessage);
        setPendingMessage(welcomeMessage);
    };

    return (
        <div className="flex h-screen bg-gray-50">
            {error && (
                <div className="absolute inset-0 flex items-center justify-center bg-gray-100 bg-opacity-50">
                    <p className="text-red-500">Lỗi: {error}</p>
                </div>
            )}
            <ChatSidebar
                sidebarOpen={sidebarOpen}
                chatHistory={chatHistory || []}
                currentChatId={conversationId}
                onNewChat={handleNewChat}
                onLoadHistory={handleChatSelect}
                onDeleteHistory={handleDelete}
            />

            <div className="flex flex-col flex-1">
                <div className="px-6 py-4 bg-white border-b border-gray-200">
                    <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-4">
                            <button
                                onClick={() => setSidebarOpen(!sidebarOpen)}
                                className="p-2 transition-colors rounded-lg hover:bg-gray-100"
                            >
                                <Menu className="w-5 h-5 text-gray-600" />
                            </button>
                            <div className="relative">
                                <div className="flex items-center justify-center w-10 h-10 shadow-sm bg-gradient-to-r from-blue-600 to-blue-700 rounded-xl">
                                    <img src={Logo} alt="LegalWise Logo" className="w-10 h-10 rounded-xl" />
                                </div>
                                <div className="absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full -bottom-1 -right-1"></div>
                            </div>
                            <div className="flex flex-col content-start justify-content-start">
                                <h1 className="text-lg font-semibold text-gray-900">LegalWise</h1>
                                <p className="text-sm text-gray-500">Trợ lý AI pháp luật thông minh</p>
                            </div>
                        </div>
                        <button
                            onClick={() => navigate("/")}
                            className="p-2 transition-colors rounded-lg hover:bg-gray-100"
                        >
                            <Home className="w-5 h-5 text-gray-500" />
                        </button>
                    </div>
                </div>

                <div className="flex-1 px-4 py-6 space-y-6 overflow-y-auto">
                    {messages.length === 0 && (
                        <div className="flex items-center justify-center h-full">
                            <div className="text-center">
                                <h2 className="text-lg font-semibold text-gray-800">
                                    Chào mừng bạn đến với LegalWise!
                                </h2>
                                <p className="mt-2 text-gray-600">
                                    Hãy đặt câu hỏi pháp luật của bạn và tôi sẽ cố gắng giúp đỡ
                                    <br />
                                    <span className="text-blue-600">Ví dụ: "Quy định về hợp đồng lao động"</span>
                                </p>
                                <p className="mt-2 text-gray-500">Bạn có thể nhập câu hỏi của mình bên dưới.</p>
                                <button
                                    onClick={addFirstMessage}
                                    className="px-4 py-2 mt-4 text-sm font-medium text-white transition-colors bg-blue-600 rounded-lg hover:bg-blue-700"
                                >
                                    Bắt đầu trò chuyện mới
                                </button>
                            </div>
                        </div>
                    )}
                    {messages.map((message) => (
                        <div
                            key={message.id}
                            className={`flex items-start space-x-3 animate-fade-in ${
                                message.type === "user" ? "justify-end" : "justify-start"
                            }`}
                        >
                            {message.type === "bot" && (
                                <div className="flex items-center justify-center flex-shrink-0 w-8 h-8 rounded-full bg-gradient-to-r from-blue-600 to-blue-700">
                                    <Bot className="w-4 h-4 text-white" />
                                </div>
                            )}
                            <div
                                className={`max-w-2xl px-4 py-3 rounded-2xl animate-scale-in ${
                                    message.type === "user"
                                        ? "bg-blue-600 text-white ml-12"
                                        : "bg-white text-gray-800 mr-12 border border-gray-200 shadow-sm"
                                }`}
                            >
                                <p className="text-sm leading-relaxed whitespace-pre-wrap">
                                    {message.type === "bot" ? message.content : message.context}
                                </p>
                                <p
                                    className={`text-xs mt-2 ${
                                        message.type === "user" ? "text-blue-100" : "text-gray-500"
                                    }`}
                                >
                                    {formatTime(message.timestamp)}
                                </p>
                            </div>
                            {message.type === "user" && (
                                <div className="flex items-center justify-center flex-shrink-0 w-8 h-8 bg-gray-100 rounded-full">
                                    <User className="w-4 h-4 text-gray-600" />
                                </div>
                            )}
                        </div>
                    ))}

                    {/* Hiển thị pending message chỉ khi đang typing */}
                    {pendingMessage && isTyping && (
                        <div className="flex items-start justify-end space-x-3 animate-fade-in">
                            <div className="max-w-2xl px-4 py-3 ml-12 text-white bg-blue-600 rounded-2xl animate-scale-in opacity-70">
                                <p className="text-sm leading-relaxed whitespace-pre-wrap">{pendingMessage.context}</p>
                                <p className="mt-2 text-xs text-blue-100">{formatTime(pendingMessage.timestamp)}</p>
                            </div>
                            <div className="flex items-center justify-center flex-shrink-0 w-8 h-8 bg-gray-100 rounded-full">
                                <User className="w-4 h-4 text-gray-600" />
                            </div>
                        </div>
                    )}

                    {isTyping && (
                        <div className="flex items-start space-x-3 animate-fade-in">
                            <div className="flex items-center justify-center w-8 h-8 rounded-full bg-gradient-to-r from-blue-600 to-blue-700 animate-pulse">
                                <Bot className="w-4 h-4 text-white" />
                            </div>
                            <div className="px-4 py-3 mr-12 bg-white border border-gray-200 shadow-sm rounded-2xl animate-scale-in">
                                <div className="flex items-center space-x-2">
                                    <div className="flex space-x-1">
                                        <div className="w-2 h-2 bg-blue-500 rounded-full animate-typing-dot"></div>
                                        <div
                                            className="w-2 h-2 bg-blue-500 rounded-full animate-typing-dot"
                                            style={{ animationDelay: "0.2s" }}
                                        ></div>
                                        <div
                                            className="w-2 h-2 bg-blue-500 rounded-full animate-typing-dot"
                                            style={{ animationDelay: "0.4s" }}
                                        ></div>
                                    </div>
                                    <span className="text-xs text-gray-500 animate-pulse">AI đang suy nghĩ...</span>
                                </div>
                            </div>
                        </div>
                    )}
                    <div ref={messagesEndRef} />
                </div>

                <div className="px-6 py-4 bg-white border-t border-gray-200">
                    <div className="flex items-end space-x-4">
                        <button className="p-2.5 hover:bg-gray-100 rounded-lg transition-colors flex-shrink-0">
                            <Paperclip className="w-5 h-5 text-gray-500" />
                        </button>
                        <div className="relative flex-1">
                            <input
                                ref={inputRef}
                                value={inputMessage}
                                onChange={(e) => setInputMessage(e.target.value)}
                                onKeyPress={handleKeyPress}
                                placeholder="Nhập câu hỏi pháp luật của bạn..."
                                className="w-full px-4 py-3 text-gray-900 placeholder-gray-500 transition-all border border-gray-200 resize-none bg-gray-50 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent max-h-32"
                                rows="1"
                                style={{
                                    minHeight: "48px",
                                    height: "auto",
                                }}
                                onInput={(e) => {
                                    e.target.style.height = "auto";
                                    e.target.style.height = Math.min(e.target.scrollHeight, 128) + "px";
                                }}
                            />
                        </div>
                        <button
                            onClick={handleSendMessage}
                            disabled={!inputMessage.trim() || isTyping}
                            className="p-2.5 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed rounded-lg transition-all duration-200 flex-shrink-0 shadow-sm"
                        >
                            <Send className="w-5 h-5 text-white" />
                        </button>
                    </div>
                    <p className="mt-2 text-xs text-center text-gray-400">
                        AI có thể mắc lỗi. Vui lòng xác minh thông tin pháp luật quan trọng.
                    </p>
                </div>
            </div>
        </div>
    );
}
