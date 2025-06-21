import React, { useState, useRef, useEffect } from "react";
import {
    Send,
    Scale,
    User,
    Bot,
    Paperclip,
    MoreVertical,
    Menu,
    Plus,
    MessageSquare,
    X,
    Search,
    Clock,
} from "lucide-react";

export default function LegalAIChatbot() {
    const [messages, setMessages] = useState([
        {
            id: 1,
            type: "bot",
            content:
                "Xin chào! Tôi là AI Luật sư - trợ lý AI chuyên về pháp luật Việt Nam. Tôi có thể giúp bạn tư vấn về các vấn đề pháp lý, giải thích điều luật, và hỗ trợ soạn thảo văn bản pháp lý. Bạn cần hỗ trợ gì hôm nay?",
            timestamp: new Date(),
        },
    ]);
    const [inputMessage, setInputMessage] = useState("");
    const [isTyping, setIsTyping] = useState(false);
    const [sidebarOpen, setSidebarOpen] = useState(true);
    const [activeChat, setActiveChat] = useState(1);
    const messagesEndRef = useRef(null);
    const inputRef = useRef(null);

    // Add custom CSS styles for animations
    useEffect(() => {
        const style = document.createElement("style");
        style.textContent = `
      @keyframes typing-dot {
        0%, 60%, 100% {
          transform: translateY(0);
          opacity: 0.4;
        }
        30% {
          transform: translateY(-10px);
          opacity: 1;
        }
      }
      
      @keyframes fade-in {
        from {
          opacity: 0;
          transform: translateY(10px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      
      @keyframes scale-in {
        from {
          transform: scale(0.95);
          opacity: 0;
        }
        to {
          transform: scale(1);
          opacity: 1;
        }
      }
      
      @keyframes wave {
        0%, 100% {
          transform: scaleX(1);
        }
        50% {
          transform: scaleX(1.1);
        }
      }
      
      .animate-typing-dot {
        animation: typing-dot 1.4s infinite ease-in-out;
      }
      
      .animate-fade-in {
        animation: fade-in 0.3s ease-out;
      }
      
      .animate-scale-in {
        animation: scale-in 0.2s ease-out;
      }
      
      .animate-wave {
        animation: wave 2s infinite ease-in-out;
      }
    `;
        document.head.appendChild(style);

        return () => {
            document.head.removeChild(style);
        };
    }, []);

    // Mock chat history data
    const [chatHistory] = useState([
        {
            id: 1,
            title: "Tư vấn hợp đồng lao động",
            lastMessage: "Cảm ơn bạn đã tư vấn về hợp đồng...",
            timestamp: new Date(Date.now() - 3600000),
            isActive: true,
        },
        {
            id: 2,
            title: "Quyền lợi người tiêu dùng",
            lastMessage: "Theo Luật Bảo vệ quyền lợi người tiêu dùng...",
            timestamp: new Date(Date.now() - 86400000),
            isActive: false,
        },
        {
            id: 3,
            title: "Thủ tục thành lập công ty",
            lastMessage: "Để thành lập công ty TNHH, bạn cần...",
            timestamp: new Date(Date.now() - 172800000),
            isActive: false,
        },
        {
            id: 4,
            title: "Tranh chấp bất động sản",
            lastMessage: "Trong trường hợp tranh chấp đất đai...",
            timestamp: new Date(Date.now() - 259200000),
            isActive: false,
        },
        {
            id: 5,
            title: "Luật hôn nhân và gia đình",
            lastMessage: "Theo điều 76 Luật Hôn nhân và Gia đình...",
            timestamp: new Date(Date.now() - 345600000),
            isActive: false,
        },
    ]);

    const scrollToBottom = () => {
        messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
    };

    useEffect(() => {
        scrollToBottom();
    }, [messages]);

    const handleSendMessage = async () => {
        if (!inputMessage.trim()) return;

        const newMessage = {
            id: messages.length + 1,
            type: "user",
            content: inputMessage,
            timestamp: new Date(),
        };

        setMessages((prev) => [...prev, newMessage]);
        setInputMessage("");
        setIsTyping(true);

        // Simulate AI response
        setTimeout(() => {
            const botResponse = {
                id: messages.length + 2,
                type: "bot",
                content:
                    "Cảm ơn bạn đã đặt câu hỏi. Đây là một câu trả lời mẫu từ AI Luật sư. Trong thực tế, đây sẽ là phản hồi chi tiết về vấn đề pháp lý mà bạn quan tâm, bao gồm các điều luật liên quan, quy định pháp lý và lời khuyên cụ thể.",
                timestamp: new Date(),
            };
            setMessages((prev) => [...prev, botResponse]);
            setIsTyping(false);
        }, 2000);
    };

    const handleKeyPress = (e) => {
        if (e.key === "Enter" && !e.shiftKey) {
            e.preventDefault();
            handleSendMessage();
        }
    };

    const formatTime = (date) => {
        return date.toLocaleTimeString("vi-VN", {
            hour: "2-digit",
            minute: "2-digit",
        });
    };

    const formatChatTime = (date) => {
        const now = new Date();
        const diffTime = now - date;
        const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

        if (diffDays === 0) {
            return formatTime(date);
        } else if (diffDays === 1) {
            return "Hôm qua";
        } else if (diffDays < 7) {
            return `${diffDays} ngày trước`;
        } else {
            return date.toLocaleDateString("vi-VN");
        }
    };

    const handleChatSelect = (chatId) => {
        setActiveChat(chatId);
        // In real app, you would load messages for this chat
    };

    const handleNewChat = () => {
        // In real app, you would create a new chat session
        console.log("Creating new chat...");
    };

    return (
        <div className="flex h-screen bg-gray-50">
            {/* Sidebar */}
            <div
                className={`${
                    sidebarOpen ? "w-80" : "w-0"
                } transition-all duration-300 bg-white border-r border-gray-200 flex flex-col overflow-hidden`}
            >
                {/* Sidebar Header */}
                <div className="p-4 border-b border-gray-200">
                    <div className="flex items-center justify-between mb-4">
                        <h2 className="text-lg font-semibold text-gray-800">Lịch sử Chat</h2>
                        <button
                            onClick={() => setSidebarOpen(false)}
                            className="p-1 transition-colors rounded-lg hover:bg-gray-100 lg:hidden"
                        >
                            <X className="w-5 h-5 text-gray-500" />
                        </button>
                    </div>

                    <button
                        onClick={handleNewChat}
                        className="w-full flex items-center justify-center space-x-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors"
                    >
                        <Plus className="w-4 h-4" />
                        <span className="font-medium">Chat mới</span>
                    </button>
                </div>

                {/* Search */}
                <div className="p-4 border-b border-gray-200">
                    <div className="relative">
                        <Search className="absolute w-4 h-4 text-gray-400 transform -translate-y-1/2 left-3 top-1/2" />
                        <input
                            type="text"
                            placeholder="Tìm kiếm cuộc trò chuyện..."
                            className="w-full py-2 pl-10 pr-4 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                        />
                    </div>
                </div>

                {/* Chat History */}
                <div className="flex-1 overflow-y-auto">
                    {chatHistory.map((chat) => (
                        <div
                            key={chat.id}
                            onClick={() => handleChatSelect(chat.id)}
                            className={`p-4 border-b border-gray-100 cursor-pointer hover:bg-gray-50 transition-colors ${
                                chat.id === activeChat ? "bg-blue-50 border-l-4 border-l-blue-600" : ""
                            }`}
                        >
                            <div className="flex items-start space-x-3">
                                <MessageSquare className="w-5 h-5 text-gray-400 mt-0.5 flex-shrink-0" />
                                <div className="flex-1 min-w-0">
                                    <h3 className="text-sm font-medium text-gray-900 truncate">{chat.title}</h3>
                                    <p className="mt-1 text-xs text-gray-500 line-clamp-2">{chat.lastMessage}</p>
                                    <div className="flex items-center mt-2 space-x-1">
                                        <Clock className="w-3 h-3 text-gray-400" />
                                        <span className="text-xs text-gray-400">{formatChatTime(chat.timestamp)}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            {/* Main Chat Area */}
            <div className="flex flex-col flex-1">
                {/* Header */}
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
                                    <Scale className="w-5 h-5 text-white" />
                                </div>
                                <div className="absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full -bottom-1 -right-1"></div>
                            </div>

                            <div>
                                <h1 className="text-lg font-semibold text-gray-900">AI Luật sư</h1>
                                <p className="text-sm text-gray-500">Trợ lý AI pháp luật thông minh</p>
                            </div>
                        </div>

                        <button className="p-2 transition-colors rounded-lg hover:bg-gray-100">
                            <MoreVertical className="w-5 h-5 text-gray-500" />
                        </button>
                    </div>
                </div>

                {/* Messages Container */}
                <div className="flex-1 px-4 py-6 space-y-6 overflow-y-auto">
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
                                <p className="text-sm leading-relaxed whitespace-pre-wrap">{message.content}</p>
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

                {/* Input Area */}
                <div className="px-6 py-4 bg-white border-t border-gray-200">
                    <div className="flex items-end space-x-4">
                        <button className="p-2.5 hover:bg-gray-100 rounded-lg transition-colors flex-shrink-0">
                            <Paperclip className="w-5 h-5 text-gray-500" />
                        </button>

                        <div className="relative flex-1">
                            <textarea
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
