import { Form, Input, Button, Typography, Card, Divider, message, Checkbox, Tooltip } from "antd";
import {
    UserOutlined,
    LockOutlined,
    GoogleOutlined,
    FacebookOutlined,
    SafetyCertificateOutlined,
    BankOutlined,
    CustomerServiceOutlined,
    EyeOutlined,
    EyeInvisibleOutlined,
} from "@ant-design/icons";
import { motion, AnimatePresence } from "framer-motion";
import { Link, useNavigate } from "react-router-dom";
import PropTypes from "prop-types";
import { useState } from "react";
import Logo from "~/assets/images/logo/logo.png";
import axios from "axios";
import SocialButton from "../SignIn/components/GoogleLoginButton";

const { Title, Text } = Typography;

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

const cardVariants = {
    hover: {
        scale: 1.02,
        transition: {
            duration: 0.2,
            ease: "easeInOut",
        },
    },
};

const SignUp = () => {
    const [form] = Form.useForm();
    const [showPassword, setShowPassword] = useState(false);
    const [isLoading, setIsLoading] = useState(false);
    const navigate = useNavigate();

    const onFinish = async (values) => {
        setIsLoading(true);
        try {
            const response = await axios.post("http://14.225.218.42:9001/api/auth/register", {
                firstName: values.firstname,
                lastName: values.lastName,
                email: values.email,
                password: values.password,
            });
            console.log("Response from server:", response.data);
            message.success("Đăng ký thành công!");
            navigate("/login");
            // Todo: Alert Success
            alert("Đăng Ký thành công");
        } catch (error) {
            console.error("Register failed:", error);
            alert("Đăng Ký thất bại");
        } finally {
            setIsLoading(false);
        }
    };

    const onFinishFailed = (errorInfo) => {
        console.log("Failed:", errorInfo);
        message.error("Vui lòng kiểm tra lại thông tin đăng ký!");
    };

    return (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
            <div className="absolute inset-0 bg-grid-pattern opacity-10"></div>
            <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ duration: 0.5 }}
                className="flex items-center justify-center min-h-screen px-4 py-12 sm:px-6 lg:px-8"
            >
                <motion.div
                    variants={containerVariants}
                    initial="hidden"
                    animate="visible"
                    className="w-full max-w-5xl space-y-8"
                >
                    <motion.div variants={itemVariants} className="text-center">
                        <div className="flex justify-center mb-6">
                            <motion.div whileHover={{ scale: 1.05, rotate: 5 }} transition={{ duration: 0.2 }}>
                                <img src={Logo} alt="LegalWise Logo" className="w-auto h-24" />
                            </motion.div>
                        </div>
                        <Title level={2} className="!mb-2 text-gray-800 font-bold">
                            Chào mừng trở lại
                        </Title>
                        <Text className="text-lg text-gray-600">Đăng ký để có thể sử dụng dịch vụ</Text>
                    </motion.div>

                    <motion.div variants={itemVariants} className="grid grid-cols-1 gap-8 lg:grid-cols-2">
                        {/* Left Column - Login Form */}
                        <motion.div variants={cardVariants} whileHover="hover">
                            <Card className="bg-white border-0 shadow-xl">
                                <Form
                                    form={form}
                                    name="register"
                                    onFinish={onFinish}
                                    onFinishFailed={onFinishFailed}
                                    layout="vertical"
                                    size="large"
                                >
                                    <Form.Item
                                        name="firstname"
                                        rules={[
                                            {
                                                required: true,
                                                message: "Vui lòng nhập họ và tên đệm!",
                                            },
                                            {
                                                type: "string",
                                                message: "Họ và tên đệm không hợp lệ!",
                                            },
                                        ]}
                                    >
                                        <Input
                                            prefix={<UserOutlined className="text-gray-400" />}
                                            placeholder="Họ và Tên Đệm"
                                            className="h-12 text-gray-700 placeholder-gray-400 transition-all duration-300 border-gray-200 rounded-lg hover:border-blue-500 focus:border-blue-500"
                                        />
                                    </Form.Item>
                                    <Form.Item
                                        name="lastName"
                                        rules={[
                                            {
                                                required: true,
                                                message: "Vui lòng nhập tên của bạn!",
                                            },
                                            {
                                                type: "string",
                                                message: "Tên của bạn không hợp lệ!!",
                                            },
                                        ]}
                                    >
                                        <Input
                                            prefix={<UserOutlined className="text-gray-400" />}
                                            placeholder="Tên của bạn"
                                            className="h-12 text-gray-700 placeholder-gray-400 transition-all duration-300 border-gray-200 rounded-lg hover:border-blue-500 focus:border-blue-500"
                                        />
                                    </Form.Item>
                                    <Form.Item
                                        name="email"
                                        rules={[
                                            {
                                                required: true,
                                                message: "Vui lòng nhập email!",
                                            },
                                            {
                                                type: "email",
                                                message: "Email không hợp lệ!",
                                            },
                                        ]}
                                    >
                                        <Input
                                            prefix={<UserOutlined className="text-gray-400" />}
                                            placeholder="Email"
                                            className="h-12 text-gray-700 placeholder-gray-400 transition-all duration-300 border-gray-200 rounded-lg hover:border-blue-500 focus:border-blue-500"
                                        />
                                    </Form.Item>

                                    <Form.Item
                                        name="password"
                                        rules={[
                                            {
                                                required: true,
                                                message: "Vui lòng nhập mật khẩu!",
                                            },
                                            {
                                                min: 6,
                                                message: "Mật khẩu phải có ít nhất 6 ký tự!",
                                            },
                                        ]}
                                    >
                                        <Input.Password
                                            prefix={<LockOutlined className="text-gray-400" />}
                                            placeholder="Mật khẩu"
                                            iconRender={(visible) =>
                                                visible ? (
                                                    <EyeOutlined
                                                        className="text-gray-400 cursor-pointer"
                                                        onClick={() => setShowPassword(!showPassword)}
                                                    />
                                                ) : (
                                                    <EyeInvisibleOutlined
                                                        className="text-gray-400 cursor-pointer"
                                                        onClick={() => setShowPassword(!showPassword)}
                                                    />
                                                )
                                            }
                                            visibilityToggle={{
                                                visible: showPassword,
                                                onVisibleChange: setShowPassword,
                                            }}
                                            className="h-12 text-gray-700 placeholder-gray-400 transition-all duration-300 border-gray-200 rounded-lg hover:border-blue-500 focus:border-blue-500"
                                        />
                                    </Form.Item>

                                    <Form.Item>
                                        <motion.div whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.98 }}>
                                            <Button
                                                type="primary"
                                                htmlType="submit"
                                                loading={isLoading}
                                                block
                                                className="h-12 text-base font-medium transition-all duration-300 border-0 rounded-lg bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700"
                                            >
                                                Đăng ký
                                            </Button>
                                        </motion.div>
                                    </Form.Item>
                                </Form>

                                <Divider className="my-6 text-gray-400">Hoặc</Divider>

                                <div className="space-y-4">
                                    <SocialButton
                                        provider="google"
                                        icon={<GoogleOutlined />}
                                        text="Đăng nhập với Google"
                                    />
                                    <SocialButton
                                        icon={<FacebookOutlined />}
                                        text="Đăng nhập với Facebook"
                                        onClick={() => console.log("Facebook login")}
                                    />
                                </div>

                                <div className="mt-6 text-center">
                                    <Text className="text-gray-600">
                                        Bạn đã có tài khoản?{" "}
                                        <Link
                                            to="/login"
                                            className="font-medium text-blue-600 transition-colors duration-300 hover:text-blue-700"
                                        >
                                            Đăng nhập ngay
                                        </Link>
                                    </Text>
                                </div>
                            </Card>
                        </motion.div>

                        {/* Right Column - Features */}
                        <div className="flex flex-col justify-center space-y-6">
                            <motion.div variants={itemVariants} className="p-8 bg-white shadow-xl rounded-xl">
                                <Title level={3} className="!mb-6 text-gray-800">
                                    Tại sao chọn LegalWise?
                                </Title>
                                <div className="space-y-6">
                                    <motion.div
                                        whileHover={{ x: 10 }}
                                        className="flex items-start space-x-4 transition-all duration-300"
                                    >
                                        <div className="flex-shrink-0">
                                            <div className="flex items-center justify-center w-12 h-12 bg-blue-100 rounded-full">
                                                <BankOutlined className="text-xl text-blue-600" />
                                            </div>
                                        </div>
                                        <div>
                                            <Text className="block mb-1 text-lg font-medium text-gray-800">
                                                Dịch vụ pháp lý chuyên nghiệp
                                            </Text>
                                            <Text className="text-gray-600">
                                                Truy cập tài liệu pháp lý và tư vấn từ các chuyên gia
                                            </Text>
                                        </div>
                                    </motion.div>
                                    <motion.div
                                        whileHover={{ x: 10 }}
                                        className="flex items-start space-x-4 transition-all duration-300"
                                    >
                                        <div className="flex-shrink-0">
                                            <div className="flex items-center justify-center w-12 h-12 bg-blue-100 rounded-full">
                                                <SafetyCertificateOutlined className="text-xl text-blue-600" />
                                            </div>
                                        </div>
                                        <div>
                                            <Text className="block mb-1 text-lg font-medium text-gray-800">
                                                Bảo mật thông tin
                                            </Text>
                                            <Text className="text-gray-600">
                                                Dữ liệu được mã hóa và bảo vệ với công nghệ SSL
                                            </Text>
                                        </div>
                                    </motion.div>
                                    <motion.div
                                        whileHover={{ x: 10 }}
                                        className="flex items-start space-x-4 transition-all duration-300"
                                    >
                                        <div className="flex-shrink-0">
                                            <div className="flex items-center justify-center w-12 h-12 bg-blue-100 rounded-full">
                                                <CustomerServiceOutlined className="text-xl text-blue-600" />
                                            </div>
                                        </div>
                                        <div>
                                            <Text className="block mb-1 text-lg font-medium text-gray-800">
                                                Hỗ trợ 24/7
                                            </Text>
                                            <Text className="text-gray-600">Đội ngũ hỗ trợ luôn sẵn sàng giúp đỡ</Text>
                                        </div>
                                    </motion.div>
                                </div>
                            </motion.div>

                            <motion.div
                                variants={itemVariants}
                                className="p-8 border border-gray-100 shadow-xl bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl"
                            >
                                <Title level={3} className="!mb-4 text-gray-800">
                                    Bắt đầu ngay hôm nay
                                </Title>
                                <Text className="block mb-6 text-gray-600">
                                    Đăng nhập tài khoản để trải nghiệm đầy đủ các tính năng của LegalWise
                                </Text>
                                <Link to="/login">
                                    <motion.div
                                        whileHover={{ scale: 1.02 }}
                                        whileTap={{ scale: 0.98 }}
                                        className="relative group"
                                    >
                                        <motion.div
                                            className="absolute inset-0 transition-opacity duration-300 rounded-lg opacity-0 bg-gradient-to-r from-blue-500 to-indigo-500 group-hover:opacity-100"
                                            initial={{ opacity: 0 }}
                                        />
                                        <Button
                                            type="primary"
                                            ghost
                                            block
                                            className="relative h-12 text-base font-medium text-blue-600 transition-all duration-300 border-2 border-blue-500 rounded-lg hover:border-transparent hover:text-white group-hover:shadow-lg"
                                        >
                                            <motion.span
                                                className="flex items-center justify-center gap-2"
                                                initial={{ x: 0 }}
                                                whileHover={{ x: 5 }}
                                                transition={{ duration: 0.2 }}
                                            >
                                                Đăng nhập tài khoản
                                                <motion.span
                                                    initial={{ opacity: 0, x: -10 }}
                                                    whileHover={{ opacity: 1, x: 0 }}
                                                    transition={{ duration: 0.2 }}
                                                >
                                                    →
                                                </motion.span>
                                            </motion.span>
                                        </Button>
                                    </motion.div>
                                </Link>
                            </motion.div>
                        </div>
                    </motion.div>

                    <motion.div
                        variants={itemVariants}
                        className="flex items-center justify-center mt-8 text-sm text-gray-500"
                    >
                        <Tooltip title="Bảo mật SSL 256-bit">
                            <SafetyCertificateOutlined className="mr-2 text-blue-500" />
                        </Tooltip>
                        <Text>Bảo mật thông tin với SSL</Text>
                    </motion.div>
                </motion.div>
            </motion.div>
        </div>
    );
};

export default SignUp;
