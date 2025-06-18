import TreeView from "./components/TreeView";
import Reader from "./components/Reader";
import { useSelector } from "react-redux"; // Thêm useSelector
import { Col, Row, Typography, Breadcrumb } from "antd";
import { motion } from "framer-motion";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBookOpen } from "@fortawesome/free-solid-svg-icons";

const { Title, Text } = Typography;

export default function TreeLaw() {
    // Loại bỏ useState, lấy chapterSelected từ Redux
    const chapterSelected = useSelector((state) => state.treelaw?.chapterSelected);

    return (
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
            className="px-4 py-6 lg:px-8"
        >
            <Breadcrumb items={[{ title: "Trang chủ", href: "/" }, { title: "Pháp Điển" }]} className="mb-6" />

            <div className="p-4 mb-8 text-center bg-white rounded-lg shadow-md">
                <Title level={2} className="mb-4">
                    <FontAwesomeIcon icon={faBookOpen} className="mr-3 text-blue-600" />
                    Pháp Điển
                </Title>
                <Text type="secondary" className="text-base">
                    Tra cứu và xem các văn bản pháp luật theo hệ thống pháp điển
                </Text>
            </div>

            <Row gutter={[24, 24]} className="mt-6">
                <Col xs={24} lg={8}>
                    <motion.div
                        initial={{ opacity: 0, x: -20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ duration: 0.5 }}
                    >
                        <TreeView />
                    </motion.div>
                </Col>
                <Col xs={24} lg={16}>
                    <motion.div
                        initial={{ opacity: 0, x: 20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ duration: 0.5 }}
                    >
                        <Reader selectedChapter={chapterSelected} />
                    </motion.div>
                </Col>
            </Row>
        </motion.div>
    );
}
