import { Button, Typography, Modal } from "antd";
import { PlusOutlined, DeleteOutlined, HistoryOutlined } from "@ant-design/icons";
import { motion } from "framer-motion";
import PropTypes from "prop-types";
import { useEffect, useState } from "react";
import { Clock, MessageSquare, Plus, Search, X } from "lucide-react";
import { Close } from "@mui/icons-material";

const { Text } = Typography;

const ChatSidebar = ({ sidebarOpen, chatHistory, currentChatId, onNewChat, onLoadHistory, onDeleteHistory }) => {
    const [activeChat, setActiveChat] = useState(currentChatId || null);
    const [sidebarVisible, setSidebarVisible] = useState();

    useEffect(() => {
        setSidebarVisible(sidebarOpen);
    }, [sidebarOpen]);
    const handleChatSelect = (chatId) => {
        setActiveChat(chatId);
        // In real app, you would load messages for this chat
    };

    const handleNewChat = () => {
        // In real app, you would create a new chat session
        console.log("Creating new chat...");
    };

    const handleDelete = (e, historyId) => {
        e.stopPropagation();
        Modal.confirm({
            title: "Xác nhận xóa",
            content: "Bạn có chắc chắn muốn xóa cuộc trò chuyện này?",
            okText: "Xóa",
            cancelText: "Hủy",
            okButtonProps: { danger: true },
            onOk: () => onDeleteHistory(historyId),
        });
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

    return (
        <div
            className={`${
                sidebarVisible ? "w-80" : "w-0"
            } transition-all duration-300 bg-white border-r border-gray-200 flex flex-col overflow-hidden`}
        >
            {/* Sidebar Header */}
            <div className="p-4 border-b border-gray-200">
                <div className="flex items-center justify-between mb-4">
                    <h2 className="text-lg font-semibold text-gray-800">Lịch sử Chat</h2>
                    <button
                        onClick={() => setSidebarVisible(false)}
                        aria-label="Đóng sidebar"
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
                            <Close
                                className="w-2 h-2 text-gray-400 cursor-pointer hover:text-red-500"
                                onClick={(e) => handleDelete(e, chat.id)}
                            />
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};
export default ChatSidebar;
