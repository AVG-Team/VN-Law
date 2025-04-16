import { Button, Typography } from "antd";
import { MenuFoldOutlined, MenuUnfoldOutlined } from "@ant-design/icons";
import PropTypes from "prop-types";
import logo from "~/assets/images/logo/logo.png";

const { Title, Text } = Typography;

const ChatHeader = ({ collapsed, onToggleCollapse }) => {
    return (
        <div className="flex items-center justify-between px-6 pt-4 mb-6 bg-gradient-to-r from-white to-gray-50 rounded-lg shadow-sm">
            <div className="flex items-center space-x-4">
                <Button
                    type="text"
                    icon={collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
                    onClick={onToggleCollapse}
                    className="text-gray-500 hover:text-blue-500"
                />
                <div className="flex items-center space-x-3">
                    <div className="w-12 h-12 rounded-full overflow-hidden bg-white shadow-md">
                        <img src={logo} alt="LegalWise" className="w-full h-full object-cover" />
                    </div>
                    <div>
                        <Title level={4} className="!mb-0">
                            LegalWise AI
                        </Title>
                        <Text type="secondary">Trợ lý pháp lý thông minh</Text>
                    </div>
                </div>
            </div>
        </div>
    );
};

ChatHeader.propTypes = {
    collapsed: PropTypes.bool.isRequired,
    onToggleCollapse: PropTypes.func.isRequired,
};

export default ChatHeader;
