import { Avatar, Typography, Button, Tooltip } from "antd";
import { CopyOutlined, CheckOutlined } from "@ant-design/icons";
import { motion } from "framer-motion";
import PropTypes from "prop-types";
import logo from "~/assets/images/logo/logo.png";

const { Text } = Typography;

const ChatMessage = ({ message, onCopy, copiedMessageId }) => {
    const isUser = message.sender === "user";

    return (
        <motion.div
            initial={{ opacity: 0, y: 20, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -20, scale: 0.95 }}
            transition={{
                duration: 0.3,
                ease: "easeOut",
            }}
            className={`flex ${isUser ? "justify-end" : "justify-start"}`}
        >
            <motion.div
                initial={{ scale: 0.95 }}
                animate={{ scale: 1 }}
                transition={{ duration: 0.2 }}
                className={`max-w-[85%] rounded-2xl p-4 ${
                    isUser ? "bg-gradient-to-r from-blue-500 to-blue-600 text-white shadow-lg" : "bg-white shadow-sm"
                }`}
            >
                <div className="flex items-start space-x-3">
                    {isUser ? (
                        <Avatar size={36} icon="U" className="bg-blue-700" />
                    ) : (
                        <div className="overflow-hidden bg-white rounded-full shadow-sm w-9 h-9">
                            <img src={logo} alt="LegalWise" className="object-cover w-full h-full" />
                        </div>
                    )}
                    <div className="flex-1">
                        <div className="flex items-center justify-between mb-2">
                            <Text className={isUser ? "text-white" : "text-gray-700"}>
                                {isUser ? "Bạn" : "LegalWise AI"}
                            </Text>
                            <Text className={`text-xs ${isUser ? "text-blue-100" : "text-gray-400"}`}>
                                {new Date(message.timestamp).toLocaleTimeString("vi-VN", {
                                    hour: "2-digit",
                                    minute: "2-digit",
                                })}
                            </Text>
                        </div>
                        <Text className={isUser ? "text-white" : "text-gray-700"}>{message.text}</Text>
                        {!isUser && (
                            <Tooltip title={copiedMessageId === message.id ? "Đã sao chép!" : "Sao chép"}>
                                <Button
                                    type="text"
                                    icon={copiedMessageId === message.id ? <CheckOutlined /> : <CopyOutlined />}
                                    onClick={() => onCopy(message.id)}
                                    className="mt-2 text-gray-400 hover:text-blue-500"
                                />
                            </Tooltip>
                        )}
                    </div>
                </div>
            </motion.div>
        </motion.div>
    );
};

ChatMessage.propTypes = {
    message: PropTypes.shape({
        id: PropTypes.number.isRequired,
        text: PropTypes.string.isRequired,
        sender: PropTypes.oneOf(["user", "bot"]).isRequired,
        timestamp: PropTypes.instanceOf(Date).isRequired,
    }).isRequired,
    onCopy: PropTypes.func.isRequired,
    copiedMessageId: PropTypes.number,
};

export default ChatMessage;
