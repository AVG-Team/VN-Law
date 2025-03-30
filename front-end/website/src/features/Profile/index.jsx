import { Card, Avatar, Typography, Button, Form, Input, Upload, Divider, Tabs, List, Tag, Space } from "antd";
import {
    UserOutlined,
    MailOutlined,
    PhoneOutlined,
    EnvironmentOutlined,
    UploadOutlined,
    EditOutlined,
    LockOutlined,
    HistoryOutlined,
    BookOutlined,
} from "@ant-design/icons";
import { motion } from "framer-motion";
import PropTypes from "prop-types";

const { Title, Text } = Typography;
const { TabPane } = Tabs;

const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
        opacity: 1,
        transition: {
            staggerChildren: 0.1,
        },
    },
};

const itemVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: {
        opacity: 1,
        y: 0,
        transition: {
            duration: 0.5,
            ease: "easeOut",
        },
    },
};

const ProfileCard = ({ user }) => (
    <motion.div
        variants={itemVariants}
        initial="hidden"
        animate="visible"
        className="bg-white rounded-xl shadow-sm p-6"
    >
        <div className="flex flex-col items-center mb-6">
            <motion.div whileHover={{ scale: 1.05 }} transition={{ duration: 0.2 }} className="relative">
                <Avatar size={120} src={user.avatar} icon={<UserOutlined />} className="border-4 border-blue-100" />
                <Upload
                    showUploadList={false}
                    className="absolute bottom-0 right-0 bg-white rounded-full p-2 shadow-md"
                >
                    <Button
                        type="primary"
                        shape="circle"
                        icon={<UploadOutlined />}
                        size="small"
                        className="bg-blue-500 hover:bg-blue-600"
                    />
                </Upload>
            </motion.div>
            <Title level={3} className="!mt-4 !mb-2">
                {user.name}
            </Title>
            <Text className="text-gray-500">{user.role}</Text>
        </div>

        <div className="space-y-4">
            <div className="flex items-center text-gray-600">
                <MailOutlined className="mr-3 text-lg" />
                <Text>{user.email}</Text>
            </div>
            <div className="flex items-center text-gray-600">
                <PhoneOutlined className="mr-3 text-lg" />
                <Text>{user.phone}</Text>
            </div>
            <div className="flex items-center text-gray-600">
                <EnvironmentOutlined className="mr-3 text-lg" />
                <Text>{user.location}</Text>
            </div>
        </div>
    </motion.div>
);

const ActivityItem = ({ activity }) => (
    <motion.div
        variants={itemVariants}
        className="bg-white rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow duration-300"
    >
        <div className="flex items-center justify-between mb-2">
            <Space>
                <Tag color="blue">{activity.type}</Tag>
                <Text className="text-gray-500">{activity.date}</Text>
            </Space>
            <Button type="text" icon={<EditOutlined />} />
        </div>
        <Text className="block">{activity.description}</Text>
    </motion.div>
);

const Profile = () => {
    // Sample data - replace with actual API call
    const user = {
        name: "Nguyễn Văn A",
        email: "example@email.com",
        phone: "0123456789",
        location: "Hà Nội, Việt Nam",
        role: "Luật sư",
        avatar: "https://picsum.photos/200",
    };

    const activities = [
        {
            id: 1,
            type: "Đăng nhập",
            date: "15/03/2024 14:30",
            description: "Đăng nhập vào hệ thống",
        },
        {
            id: 2,
            type: "Tìm kiếm",
            date: "15/03/2024 14:35",
            description: "Tìm kiếm thông tin về Luật Doanh nghiệp",
        },
        {
            id: 3,
            type: "Tải xuống",
            date: "15/03/2024 14:40",
            description: "Tải xuống tài liệu pháp lý",
        },
    ];

    return (
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
            className="container mx-auto px-4 py-8"
        >
            <motion.div
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5 }}
                className="mb-6"
            >
                <Title level={2}>Thông tin cá nhân</Title>
            </motion.div>

            <motion.div
                variants={containerVariants}
                initial="hidden"
                animate="visible"
                className="grid grid-cols-1 lg:grid-cols-3 gap-6"
            >
                {/* Profile Card */}
                <div className="lg:col-span-1">
                    <ProfileCard user={user} />
                </div>

                {/* Tabs Section */}
                <div className="lg:col-span-2">
                    <Card className="shadow-sm">
                        <Tabs defaultActiveKey="1">
                            <TabPane
                                tab={
                                    <span>
                                        <LockOutlined />
                                        Đổi mật khẩu
                                    </span>
                                }
                                key="1"
                            >
                                <Form layout="vertical" className="max-w-md">
                                    <Form.Item label="Mật khẩu hiện tại">
                                        <Input.Password />
                                    </Form.Item>
                                    <Form.Item label="Mật khẩu mới">
                                        <Input.Password />
                                    </Form.Item>
                                    <Form.Item label="Xác nhận mật khẩu mới">
                                        <Input.Password />
                                    </Form.Item>
                                    <Form.Item>
                                        <Button type="primary" block>
                                            Cập nhật mật khẩu
                                        </Button>
                                    </Form.Item>
                                </Form>
                            </TabPane>

                            <TabPane
                                tab={
                                    <span>
                                        <HistoryOutlined />
                                        Hoạt động
                                    </span>
                                }
                                key="2"
                            >
                                <List
                                    dataSource={activities}
                                    renderItem={(activity) => (
                                        <List.Item>
                                            <ActivityItem activity={activity} />
                                        </List.Item>
                                    )}
                                    className="space-y-4"
                                />
                            </TabPane>

                            <TabPane
                                tab={
                                    <span>
                                        <BookOutlined />
                                        Tài liệu đã lưu
                                    </span>
                                }
                                key="3"
                            >
                                <Text className="text-gray-500">Chưa có tài liệu nào được lưu</Text>
                            </TabPane>
                        </Tabs>
                    </Card>
                </div>
            </motion.div>
        </motion.div>
    );
};

ProfileCard.propTypes = {
    user: PropTypes.shape({
        name: PropTypes.string.isRequired,
        email: PropTypes.string.isRequired,
        phone: PropTypes.string.isRequired,
        location: PropTypes.string.isRequired,
        role: PropTypes.string.isRequired,
        avatar: PropTypes.string.isRequired,
    }).isRequired,
};

ActivityItem.propTypes = {
    activity: PropTypes.shape({
        type: PropTypes.string.isRequired,
        date: PropTypes.string.isRequired,
        description: PropTypes.string.isRequired,
    }).isRequired,
};

export default Profile;
