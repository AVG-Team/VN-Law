import { Button, Typography, Modal } from "antd";
import { PlusOutlined, DeleteOutlined, HistoryOutlined } from "@ant-design/icons";
import { motion } from "framer-motion";
import PropTypes from "prop-types";
import logo from "~/assets/images/logo/logo.png";

const { Text } = Typography;

const ChatSidebar = ({ collapsed, chatHistory, currentChatId, onNewChat, onLoadHistory, onDeleteHistory }) => {
    const formatDate = (date) => {
        return new Date(date).toLocaleDateString("vi-VN", {
            year: "numeric",
            month: "long",
            day: "numeric",
            hour: "2-digit",
            minute: "2-digit",
        });
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

    return (
        <motion.div
            initial={{ width: collapsed ? 0 : 320 }}
            animate={{ width: collapsed ? 0 : 320 }}
            className="flex flex-col h-full overflow-hidden border-r border-gray-200 shadow-sm bg-gradient-to-b from-white to-gray-50"
        >
            {/* New Chat Button */}
            <div className="p-4 bg-white border-b border-gray-100">
                <Button
                    type="primary"
                    icon={<PlusOutlined />}
                    onClick={onNewChat}
                    className="flex items-center justify-center w-full text-base transition-all duration-200 border-none bg-gradient-to-r from-blue-600 to-blue-700 h-11 hover:from-blue-700 hover:to-blue-800"
                >
                    Cuộc trò chuyện mới
                </Button>
            </div>

            {/* History List */}
            <div className="flex-1 overflow-y-auto">
                <div className="p-2 space-y-1">
                    {chatHistory.length === 0 ? (
                        <div className="flex flex-col items-center justify-center h-full py-8 text-gray-400">
                            <HistoryOutlined className="mb-4 text-4xl" />
                            <Text>Chưa có lịch sử chat</Text>
                        </div>
                    ) : (
                        chatHistory.map((item) => (
                            <motion.div
                                key={item.id}
                                initial={{ opacity: 0, x: -20 }}
                                animate={{ opacity: 1, x: 0 }}
                                exit={{ opacity: 0, x: -20 }}
                                className={`group relative p-3 rounded-lg cursor-pointer transition-all duration-200 ${
                                    currentChatId === item.id
                                        ? "bg-gradient-to-r from-blue-50 to-blue-100 text-blue-600 shadow-md"
                                        : "bg-white hover:bg-gray-50 hover:shadow-sm"
                                }`}
                                onClick={() => onLoadHistory(item)}
                            >
                                <div className="flex items-start space-x-3">
                                    <div
                                        className={`flex-shrink-0 w-8 h-8 rounded-full overflow-hidden shadow-sm ${
                                            currentChatId === item.id ? "bg-blue-100" : "bg-gray-100"
                                        }`}
                                    >
                                        <img
                                            src={logo}
                                            alt="LegalWise"
                                            className={`w-full h-full object-cover ${
                                                currentChatId === item.id ? "opacity-100" : "opacity-70"
                                            }`}
                                        />
                                    </div>
                                    <div className="flex-1 min-w-0">
                                        <div className="flex flex-col">
                                            <Text
                                                strong
                                                className={`block truncate text-sm sm:text-base ${
                                                    currentChatId === item.id ? "text-blue-600" : "text-gray-700"
                                                }`}
                                                ellipsis={{ tooltip: item.title }}
                                            >
                                                {item.title}
                                            </Text>
                                            <Text type="secondary" className="text-xs mt-0.5">
                                                {formatDate(item.timestamp)}
                                            </Text>
                                        </div>
                                    </div>
                                    <Button
                                        type="text"
                                        danger
                                        icon={<DeleteOutlined />}
                                        onClick={(e) => handleDelete(e, item.id)}
                                        className="absolute transition-opacity -translate-y-1/2 opacity-0 right-2 top-1/2 group-hover:opacity-100"
                                    />
                                </div>
                            </motion.div>
                        ))
                    )}
                </div>
            </div>
        </motion.div>
    );
};

ChatSidebar.propTypes = {
    collapsed: PropTypes.bool.isRequired,
    chatHistory: PropTypes.arrayOf(
        PropTypes.shape({
            id: PropTypes.number.isRequired,
            title: PropTypes.string.isRequired,
            messages: PropTypes.array.isRequired,
            timestamp: PropTypes.instanceOf(Date).isRequired,
        }),
    ).isRequired,
    currentChatId: PropTypes.number,
    onNewChat: PropTypes.func.isRequired,
    onLoadHistory: PropTypes.func.isRequired,
    onDeleteHistory: PropTypes.func.isRequired,
};

export default ChatSidebar;
