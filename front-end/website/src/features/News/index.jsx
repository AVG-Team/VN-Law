import { Card, Row, Col, Typography, Tag, Space, Button, Input, Select, Carousel, Divider, Breadcrumb } from "antd";
import {
    SearchOutlined,
    CalendarOutlined,
    UserOutlined,
    EyeOutlined,
    FireOutlined,
    HomeOutlined,
} from "@ant-design/icons";
import { motion, AnimatePresence } from "framer-motion";
import PropTypes from "prop-types";
import { Link } from "react-router-dom";

const { Title, Text } = Typography;
const { Search } = Input;
const { Option } = Select;

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

const FeaturedNewsCard = ({ news }) => (
    <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, ease: "easeOut" }}
        className="relative h-[400px] sm:h-[500px] rounded-2xl overflow-hidden group"
    >
        <motion.img
            alt={news.title}
            src={news.image}
            className="w-full h-full object-cover"
            whileHover={{ scale: 1.1 }}
            transition={{ duration: 0.5, ease: "easeOut" }}
        />
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5, delay: 0.2 }}
            className="absolute inset-0 bg-gradient-to-t from-black/80 to-transparent"
        />
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.3 }}
            className="absolute bottom-0 left-0 right-0 p-6 sm:p-8 text-white"
        >
            <motion.div
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.5, delay: 0.4 }}
                className="flex flex-wrap gap-2 mb-3"
            >
                {news.tags.map((tag, index) => (
                    <motion.div
                        key={tag}
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.3, delay: 0.5 + index * 0.1 }}
                    >
                        <Tag color="blue" className="bg-blue-500/20 border-blue-500/30 text-white">
                            {tag}
                        </Tag>
                    </motion.div>
                ))}
            </motion.div>
            <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: 0.6 }}
            >
                <Title level={3} className="!text-white !mb-2 line-clamp-2">
                    {news.title}
                </Title>
                <Text className="text-white/80 line-clamp-2 block mb-4">{news.description}</Text>
                <div className="flex items-center justify-between text-sm text-white/70">
                    <Space>
                        <span className="flex items-center">
                            <CalendarOutlined className="mr-1" />
                            {news.date}
                        </span>
                        <span className="flex items-center">
                            <UserOutlined className="mr-1" />
                            {news.author}
                        </span>
                    </Space>
                    <span className="flex items-center">
                        <EyeOutlined className="mr-1" />
                        {news.views}
                    </span>
                </div>
            </motion.div>
        </motion.div>
    </motion.div>
);

const NewsCard = ({ news, variant = "default" }) => {
    if (variant === "compact") {
        return (
            <motion.div
                variants={itemVariants}
                initial="hidden"
                animate="visible"
                whileHover={{ scale: 1.02 }}
                transition={{ duration: 0.2 }}
                className="bg-white rounded-xl shadow-sm hover:shadow-md transition-shadow duration-300"
            >
                <div className="flex h-full">
                    <motion.div
                        whileHover={{ scale: 1.05 }}
                        transition={{ duration: 0.2 }}
                        className="w-1/3 overflow-hidden"
                    >
                        <img
                            alt={news.title}
                            src={news.image}
                            className="w-full h-full object-cover rounded-l-xl"
                            onError={(e) => {
                                e.target.onerror = null;
                                e.target.src = "https://via.placeholder.com/400x300?text=No+Image";
                            }}
                        />
                    </motion.div>
                    <div className="w-2/3 p-4">
                        <motion.div
                            initial={{ opacity: 0, y: 10 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ duration: 0.3 }}
                            className="flex flex-wrap gap-2 mb-2"
                        >
                            {news.tags.map((tag) => (
                                <Tag key={tag} color="blue" className="bg-blue-50 border-blue-100 text-blue-600">
                                    {tag}
                                </Tag>
                            ))}
                        </motion.div>
                        <Title level={5} className="!mb-2 line-clamp-2">
                            {news.title}
                        </Title>
                        <div className="flex items-center justify-between text-sm text-gray-500">
                            <Space>
                                <span className="flex items-center">
                                    <CalendarOutlined className="mr-1" />
                                    {news.date}
                                </span>
                                <span className="flex items-center">
                                    <UserOutlined className="mr-1" />
                                    {news.author}
                                </span>
                            </Space>
                            <span className="flex items-center">
                                <EyeOutlined className="mr-1" />
                                {news.views}
                            </span>
                        </div>
                    </div>
                </div>
            </motion.div>
        );
    }

    return (
        <motion.div
            variants={itemVariants}
            initial="hidden"
            animate="visible"
            whileHover={{ scale: 1.02 }}
            transition={{ duration: 0.2 }}
        >
            <Card
                hoverable
                cover={
                    <motion.div whileHover={{ scale: 1.05 }} transition={{ duration: 0.2 }} className="overflow-hidden">
                        <img
                            alt={news.title}
                            src={news.image}
                            className="h-48 sm:h-64 w-full object-cover"
                            onError={(e) => {
                                e.target.onerror = null;
                                e.target.src = "https://via.placeholder.com/800x600?text=No+Image";
                            }}
                        />
                    </motion.div>
                }
                className="h-full shadow-sm hover:shadow-md transition-shadow duration-300"
            >
                <motion.div
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.3 }}
                    className="space-y-3"
                >
                    <div className="flex flex-wrap gap-2">
                        {news.tags.map((tag) => (
                            <Tag key={tag} color="blue" className="bg-blue-50 border-blue-100 text-blue-600">
                                {tag}
                            </Tag>
                        ))}
                    </div>
                    <Title level={4} className="!mb-2 line-clamp-2">
                        {news.title}
                    </Title>
                    <Text className="text-gray-500 line-clamp-3 block">{news.description}</Text>
                    <div className="flex items-center justify-between text-sm text-gray-500">
                        <Space>
                            <span className="flex items-center">
                                <CalendarOutlined className="mr-1" />
                                {news.date}
                            </span>
                            <span className="flex items-center">
                                <UserOutlined className="mr-1" />
                                {news.author}
                            </span>
                        </Space>
                        <span className="flex items-center">
                            <EyeOutlined className="mr-1" />
                            {news.views}
                        </span>
                    </div>
                </motion.div>
            </Card>
        </motion.div>
    );
};

NewsCard.propTypes = {
    news: PropTypes.shape({
        title: PropTypes.string.isRequired,
        description: PropTypes.string.isRequired,
        image: PropTypes.string.isRequired,
        date: PropTypes.string.isRequired,
        author: PropTypes.string.isRequired,
        views: PropTypes.number.isRequired,
        tags: PropTypes.arrayOf(PropTypes.string).isRequired,
    }).isRequired,
    variant: PropTypes.oneOf(["default", "compact"]),
};

const News = () => {
    // Sample data - replace with actual API call
    const featuredNews = {
        id: 1,
        title: "Cập nhật mới nhất về Luật Doanh nghiệp 2024",
        description:
            "Những thay đổi quan trọng trong Luật Doanh nghiệp 2024 và tác động đến doanh nghiệp Việt Nam. Cập nhật chi tiết về các quy định mới và hướng dẫn thực hiện.",
        image: "https://picsum.photos/1920/1080",
        date: "15/03/2024",
        author: "Admin",
        views: 1234,
        tags: ["Luật Doanh nghiệp", "Cập nhật", "Quy định mới"],
    };

    const newsData = [
        {
            id: 2,
            title: "Hướng dẫn thủ tục đăng ký doanh nghiệp mới",
            description: "Chi tiết các bước thực hiện thủ tục đăng ký doanh nghiệp mới theo quy định hiện hành.",
            image: "https://picsum.photos/800/601",
            date: "14/03/2024",
            author: "Admin",
            views: 856,
            tags: ["Thủ tục", "Đăng ký"],
        },
        {
            id: 3,
            title: "Quy định mới về thuế doanh nghiệp 2024",
            description: "Tổng hợp các thay đổi về thuế doanh nghiệp trong năm 2024 và cách áp dụng.",
            image: "https://picsum.photos/800/602",
            date: "13/03/2024",
            author: "Admin",
            views: 654,
            tags: ["Thuế", "Quy định"],
        },
        {
            id: 4,
            title: "Hướng dẫn báo cáo tài chính doanh nghiệp",
            description: "Chi tiết về các loại báo cáo tài chính và thời hạn nộp báo cáo theo quy định.",
            image: "https://picsum.photos/800/603",
            date: "12/03/2024",
            author: "Admin",
            views: 432,
            tags: ["Báo cáo", "Tài chính"],
        },
    ];

    return (
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
            className="container mx-auto px-4 py-8"
        >
            {/* Breadcrumb */}
            <motion.div
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5 }}
                className="mb-6"
            >
                <Breadcrumb
                    items={[
                        {
                            title: (
                                <Link to="/" className="flex items-center">
                                    <HomeOutlined className="mr-1" />
                                    Trang chủ
                                </Link>
                            ),
                            key: "home",
                        },
                        {
                            title: "Tin tức pháp luật",
                            key: "news",
                        },
                    ]}
                    className="text-sm"
                />
            </motion.div>

            {/* Header Section */}
            <motion.div
                initial={{ opacity: 0, y: -20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5 }}
                className="mb-8"
            >
                <div className="flex items-center justify-between mb-4">
                    <Title level={2} className="!mb-0">
                        Tin tức pháp luật
                    </Title>
                    <motion.div whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }}>
                        <Button type="primary" icon={<FireOutlined />}>
                            Tin nóng
                        </Button>
                    </motion.div>
                </div>
                <div className="flex flex-col sm:flex-row gap-4">
                    <Search
                        placeholder="Tìm kiếm tin tức..."
                        allowClear
                        enterButton={<SearchOutlined />}
                        size="large"
                        className="flex-1"
                    />
                    <Select defaultValue="all" size="large" className="w-full sm:w-48">
                        <Option value="all">Tất cả</Option>
                        <Option value="latest">Mới nhất</Option>
                        <Option value="popular">Phổ biến</Option>
                    </Select>
                </div>
            </motion.div>

            {/* Featured News */}
            <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: 0.2 }}
                className="mb-12"
            >
                <FeaturedNewsCard news={featuredNews} />
            </motion.div>

            <Divider />

            {/* Latest News Section */}
            <motion.div variants={containerVariants} initial="hidden" animate="visible" className="mb-12">
                <Title level={3} className="!mb-6">
                    Tin tức mới nhất
                </Title>
                <Row gutter={[24, 24]}>
                    {newsData.map((news) => (
                        <Col key={news.id} xs={24} sm={12} lg={8}>
                            <NewsCard news={news} />
                        </Col>
                    ))}
                </Row>
            </motion.div>

            {/* Popular News Section */}
            <motion.div variants={containerVariants} initial="hidden" animate="visible" className="mb-12">
                <Title level={3} className="!mb-6">
                    Tin tức phổ biến
                </Title>
                <div className="space-y-4">
                    {newsData.map((news) => (
                        <NewsCard key={news.id} news={news} variant="compact" />
                    ))}
                </div>
            </motion.div>

            {/* Load More Button */}
            <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: 0.4 }}
                className="text-center"
            >
                <motion.div whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }}>
                    <Button type="primary" size="large" className="px-8">
                        Xem thêm
                    </Button>
                </motion.div>
            </motion.div>
        </motion.div>
    );
};

export default News;
