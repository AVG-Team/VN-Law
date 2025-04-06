import PropTypes from "prop-types";
import { useEffect, useState } from "react";
import { Col, Pagination, Row, Card, Tag, Select, Input, Breadcrumb, Space, Typography, Button } from "antd";
import { SearchOutlined, FileTextOutlined, CalendarOutlined, FilterOutlined, ReloadOutlined } from "@ant-design/icons";
import VbqpplApi from "~/services/vbqpplApi";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faFileLines, faScaleBalanced } from "@fortawesome/free-solid-svg-icons";
import { motion } from "framer-motion";

const { Title, Text } = Typography;
const { Option } = Select;

const categories = [
    { id: "1", name: "Luật", icon: "⚖️" },
    { id: "2", name: "Nghị Định", icon: "📜" },
    { id: "3", name: "Quyết Định", icon: "📋" },
    { id: "4", name: "Thông Tư", icon: "📄" },
    { id: "5", name: "Chính trị", icon: "🏛️" },
];

const sortOptions = [
    { value: "newest", label: "Mới nhất", icon: "🆕" },
    { value: "oldest", label: "Cũ nhất", icon: "📅" },
    { value: "title", label: "Tên văn bản", icon: "📝" },
];

const VBQPPL = (props) => {
    const [page, setPage] = useState(1);
    const [pageSize, setPageSize] = useState(9);
    const [total, setTotal] = useState(0);
    const [content, setContent] = useState([]);
    const [type, setType] = useState("");
    const [searchText, setSearchText] = useState("");
    const [sortBy, setSortBy] = useState("newest");
    const [isFilterVisible, setIsFilterVisible] = useState(false);

    VBQPPL.propTypes = {
        title: PropTypes.string.isRequired,
    };

    const { title } = props;

    useEffect(() => {
        document.title = title || "Trang không tồn tại";
    }, [title]);

    const handleCategoryChange = (value) => {
        setType(value);
        setPage(1);
    };

    const handleSearch = (value) => {
        setSearchText(value);
        setPage(1);
    };

    const handleSortChange = (value) => {
        setSortBy(value);
        setPage(1);
    };

    const handleReset = () => {
        setType("");
        setSearchText("");
        setSortBy("newest");
        setPage(1);
    };

    useEffect(() => {
        const fetchData = async () => {
            try {
                const { content, totalElements, size } = await VbqpplApi.filter({
                    type,
                    pageNo: page,
                    pageSize,
                    search: searchText,
                    sortBy,
                });
                setContent(content);
                setTotal(Math.ceil(totalElements / size));
            } catch (error) {
                console.error("Error fetching data:", error);
            }
        };

        fetchData();
    }, [type, page, pageSize, searchText, sortBy]);

    return (
        <div className="px-4 py-6 lg:px-8">
            <Breadcrumb
                items={[{ title: "Trang chủ", href: "/" }, { title: "Văn bản quy phạm pháp luật" }]}
                className="mb-6"
            />

            <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5 }}
                className="p-8 bg-white border border-gray-100 shadow-sm rounded-xl"
            >
                <div className="mb-8 text-center">
                    <Title level={2} className="mb-4">
                        <FontAwesomeIcon icon={faScaleBalanced} className="mr-3 text-blue-600" />
                        Văn bản quy phạm pháp luật
                    </Title>
                    <Text type="secondary" className="text-base">
                        Tra cứu và xem các văn bản quy phạm pháp luật mới nhất
                    </Text>
                </div>

                <div className="flex justify-end mb-4">
                    <Button
                        type="text"
                        icon={<FilterOutlined />}
                        onClick={() => setIsFilterVisible(!isFilterVisible)}
                        className="text-blue-600 hover:text-blue-800"
                    >
                        {isFilterVisible ? "Ẩn bộ lọc" : "Hiển thị bộ lọc"}
                    </Button>
                </div>

                <motion.div
                    initial={false}
                    animate={{ height: isFilterVisible ? "auto" : 0, opacity: isFilterVisible ? 1 : 0 }}
                    transition={{ duration: 0.3 }}
                    className="overflow-hidden"
                >
                    <div className="grid grid-cols-1 gap-4 mb-6 md:grid-cols-3">
                        <Select
                            placeholder="Chọn loại văn bản"
                            className="w-full"
                            onChange={handleCategoryChange}
                            value={type}
                            allowClear
                            suffixIcon={<FontAwesomeIcon icon={faFileLines} />}
                        >
                            {categories.map((item) => (
                                <Option key={item.id} value={item.name}>
                                    <span className="mr-2">{item.icon}</span>
                                    {item.name}
                                </Option>
                            ))}
                        </Select>

                        <Input
                            placeholder="Tìm kiếm văn bản..."
                            prefix={<SearchOutlined className="text-gray-400" />}
                            onChange={(e) => handleSearch(e.target.value)}
                            className="w-full"
                            value={searchText}
                        />

                        <div className="flex gap-2">
                            <Select
                                placeholder="Sắp xếp theo"
                                className="w-full"
                                onChange={handleSortChange}
                                value={sortBy}
                            >
                                {sortOptions.map((option) => (
                                    <Option key={option.value} value={option.value}>
                                        <span className="mr-2">{option.icon}</span>
                                        {option.label}
                                    </Option>
                                ))}
                            </Select>
                            <Button
                                icon={<ReloadOutlined />}
                                onClick={handleReset}
                                className="flex items-center justify-center"
                            />
                        </div>
                    </div>
                </motion.div>
            </motion.div>

            <Row gutter={[16, 16]} className="mt-6">
                {content.map((item, index) => (
                    <Col key={item.id} xs={24} sm={12} md={8} lg={6}>
                        <motion.div
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ duration: 0.5, delay: index * 0.1 }}
                        >
                            <Card
                                hoverable
                                onClick={() => window.open(`/vbqppl/${item.id}`, "_self")}
                                className="h-full transition-all duration-300 hover:shadow-lg hover:border-blue-200"
                                cover={
                                    <div className="p-4 bg-gradient-to-br from-gray-50 to-white">
                                        <div className="flex items-center justify-between mb-2">
                                            <Tag color="blue" className="px-3 py-1 rounded-full">
                                                {item.type}
                                            </Tag>
                                            <Text type="secondary" className="flex items-center text-sm">
                                                <CalendarOutlined className="mr-1" />
                                                {new Date(item.date).toLocaleDateString("vi-VN")}
                                            </Text>
                                        </div>
                                        <Title
                                            level={4}
                                            className="mb-2 transition-colors line-clamp-2 hover:text-blue-600"
                                        >
                                            {item.title}
                                        </Title>
                                        <Text type="secondary" className="text-sm line-clamp-2">
                                            {item.description}
                                        </Text>
                                    </div>
                                }
                            >
                                <div className="flex items-center justify-between">
                                    <Text type="secondary" className="flex items-center text-sm">
                                        <FileTextOutlined className="mr-1" />
                                        Số hiệu: {item.number}
                                    </Text>
                                    <Text type="secondary" className="text-sm">
                                        {item.pages} trang
                                    </Text>
                                </div>
                            </Card>
                        </motion.div>
                    </Col>
                ))}
            </Row>

            <div className="flex justify-center mt-8">
                <Pagination
                    current={page}
                    onChange={setPage}
                    pageSizeOptions={[9, 18, 36]}
                    pageSize={pageSize}
                    onShowSizeChange={(current, size) => {
                        setPageSize(size);
                        setPage(1);
                    }}
                    total={total}
                    showSizeChanger
                    showQuickJumper
                    showTotal={(total) => `Tổng số ${total} văn bản`}
                    className="custom-pagination"
                />
            </div>
        </div>
    );
};

export default VBQPPL;
