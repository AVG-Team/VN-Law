import { Input, Button } from "antd";
import { SendOutlined } from "@ant-design/icons";
import PropTypes from "prop-types";

const { TextArea } = Input;

const ChatInput = ({ value, onChange, onSend, loading }) => {
    return (
        <div className="px-6 py-4 bg-white border-t border-gray-100">
            <div className="flex items-center space-x-4">
                <TextArea
                    value={value}
                    onChange={onChange}
                    placeholder="Nhập câu hỏi của bạn..."
                    autoSize={{ minRows: 1, maxRows: 4 }}
                    onPressEnter={(e) => {
                        if (!e.shiftKey) {
                            e.preventDefault();
                            onSend();
                        }
                    }}
                    className="flex-1 rounded-xl"
                />
                <Button
                    type="primary"
                    icon={<SendOutlined />}
                    onClick={onSend}
                    loading={loading}
                    disabled={!value.trim()}
                    className="h-10 px-6 bg-blue-600 hover:bg-blue-700 border-none rounded-xl"
                />
            </div>
        </div>
    );
};

ChatInput.propTypes = {
    value: PropTypes.string.isRequired,
    onChange: PropTypes.func.isRequired,
    onSend: PropTypes.func.isRequired,
    loading: PropTypes.bool.isRequired,
};

export default ChatInput;
