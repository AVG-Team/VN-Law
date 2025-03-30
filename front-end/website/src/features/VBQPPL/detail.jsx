import "./components/style.css";
import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Worker } from "@react-pdf-viewer/core";
import VbqpplApi from "~/services/vbqpplApi";
import "@react-pdf-viewer/core/lib/styles/index.css";
import "@react-pdf-viewer/default-layout/lib/styles/index.css";
import { DocumentIcon, ArrowDownTrayIcon, EyeIcon, ArrowLeftIcon } from "@heroicons/react/24/solid";
import Localization from "./components/Localization";
import { Breadcrumb, Typography, Card, Descriptions, Button, Space, Divider, Tag, Tooltip, Badge } from "antd";
import { ShareAltOutlined, PrinterOutlined, BookOutlined, LinkOutlined, HistoryOutlined } from "@ant-design/icons";
import { motion } from "framer-motion";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faScaleBalanced, faFileSignature } from "@fortawesome/free-solid-svg-icons";

const { Title, Text } = Typography;

export default function Detail(props) {
    const [isViewPdf, setIsViewPdf] = useState(false);
    const [vbqppl, setVbqppl] = useState({});
    const [relatedDocs, setRelatedDocs] = useState([]);
    const navigate = useNavigate();
    let { param } = useParams();
    const id = param;

    useEffect(() => {
        const fetchData = async () => {
            try {
                const data = await VbqpplApi.getById(id);
                setVbqppl(data);

                // Fetch related documents
                const related = await VbqpplApi.filter({
                    type: data.type,
                    pageSize: 3,
                    excludeId: id,
                });
                setRelatedDocs(related.content);
            } catch (error) {
                console.error("Error fetching data:", error);
            }
        };
        fetchData();
    }, [id]);

    const handleViewPDF = () => {
        setIsViewPdf(true);
    };

    const handleDownload = () => {
        // Implement download functionality
        console.log("Downloading document...");
    };

    const handlePrint = () => {
        window.print();
    };

    const handleShare = () => {
        if (navigator.share) {
            navigator.share({
                title: vbqppl.title,
                text: vbqppl.description,
                url: window.location.href,
            });
        }
    };

    return (
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
            className="px-4 py-6 lg:px-8"
        >
            <Breadcrumb
                items={[
                    { title: "Trang chủ", href: "/" },
                    { title: "Văn bản quy phạm pháp luật", href: "/vbqppl" },
                    { title: vbqppl.title || "Chi tiết văn bản" },
                ]}
                className="mb-6"
            />

            <div className="flex items-center justify-between mb-6">
                <div className="flex items-center space-x-4">
                    <Button
                        type="text"
                        icon={<ArrowLeftIcon className="w-4 h-4" />}
                        onClick={() => navigate(-1)}
                        className="hover:text-blue-600"
                    >
                        Quay lại
                    </Button>
                    <Badge status="processing" text="Đang hiệu lực" />
                </div>
                <Space>
                    <Tooltip title="Chia sẻ">
                        <Button icon={<ShareAltOutlined />} onClick={handleShare} className="hover:text-blue-600" />
                    </Tooltip>
                    <Tooltip title="In văn bản">
                        <Button icon={<PrinterOutlined />} onClick={handlePrint} className="hover:text-blue-600" />
                    </Tooltip>
                </Space>
            </div>

            <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
                <div className="lg:col-span-2">
                    <motion.div
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.5 }}
                    >
                        <Card className="mb-6 transition-shadow shadow-sm hover:shadow-md">
                            <div className="flex items-center mb-4">
                                <FontAwesomeIcon icon={faScaleBalanced} className="mr-3 text-2xl text-blue-600" />
                                <Title level={2} className="!mb-0">
                                    {vbqppl.title}
                                </Title>
                            </div>
                            <Tag color="blue" className="px-3 py-1 mb-4 rounded-full">
                                {vbqppl.type}
                            </Tag>

                            <Descriptions bordered column={2}>
                                <Descriptions.Item label="Số hiệu">
                                    <span className="font-medium">{vbqppl.number}</span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Ngày ban hành">
                                    <span className="font-medium">
                                        {new Date(vbqppl.date).toLocaleDateString("vi-VN")}
                                    </span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Cơ quan ban hành">
                                    <span className="font-medium">{vbqppl.issuingBody}</span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Trạng thái">
                                    <Badge status="success" text={vbqppl.status} />
                                </Descriptions.Item>
                            </Descriptions>

                            <div className="mt-6">
                                <Title level={4} className="flex items-center">
                                    <BookOutlined className="mr-2 text-blue-600" />
                                    Nội dung văn bản
                                </Title>
                                <div className="flex space-x-4">
                                    <Button
                                        type="primary"
                                        icon={<DocumentIcon className="w-4 h-4" />}
                                        onClick={handleDownload}
                                        className="flex items-center"
                                    >
                                        Tải xuống PDF
                                    </Button>
                                    <Button
                                        icon={<EyeIcon className="w-4 h-4" />}
                                        onClick={handleViewPDF}
                                        className="flex items-center"
                                    >
                                        Xem trực tuyến
                                    </Button>
                                </div>
                            </div>
                        </Card>
                    </motion.div>

                    {isViewPdf && (
                        <motion.div
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ duration: 0.5 }}
                        >
                            <Card className="mb-6 shadow-sm">
                                <Worker workerUrl="https://unpkg.com/pdfjs-dist@3.4.120/build/pdf.worker.min.js">
                                    <Localization item={vbqppl.html} />
                                </Worker>
                            </Card>
                        </motion.div>
                    )}
                </div>

                <div className="lg:col-span-1">
                    <motion.div
                        initial={{ opacity: 0, x: 20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ duration: 0.5, delay: 0.2 }}
                    >
                        <Card
                            title={
                                <div className="flex items-center">
                                    <LinkOutlined className="mr-2 text-blue-600" />
                                    Văn bản liên quan
                                </div>
                            }
                            className="mb-6 shadow-sm"
                        >
                            {relatedDocs.map((doc) => (
                                <div
                                    key={doc.id}
                                    className="p-2 mb-4 transition-colors rounded-lg last:mb-0 hover:bg-gray-50"
                                >
                                    <a
                                        href={`/vbqppl/${doc.id}`}
                                        className="block transition-colors hover:text-blue-600"
                                    >
                                        <Text className="block font-medium">{doc.title}</Text>
                                        <Text type="secondary" className="text-sm">
                                            {doc.number} - {new Date(doc.date).toLocaleDateString("vi-VN")}
                                        </Text>
                                    </a>
                                </div>
                            ))}
                        </Card>

                        <Card
                            title={
                                <div className="flex items-center">
                                    <HistoryOutlined className="mr-2 text-blue-600" />
                                    Thông tin bổ sung
                                </div>
                            }
                            className="shadow-sm"
                        >
                            <Descriptions column={1}>
                                <Descriptions.Item label="Ngày có hiệu lực">
                                    <span className="font-medium">
                                        {new Date(vbqppl.effectiveDate).toLocaleDateString("vi-VN")}
                                    </span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Ngày hết hiệu lực">
                                    <span className="font-medium">
                                        {vbqppl.expiryDate
                                            ? new Date(vbqppl.expiryDate).toLocaleDateString("vi-VN")
                                            : "Chưa có"}
                                    </span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Lĩnh vực">
                                    <span className="font-medium">{vbqppl.field}</span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Từ khóa">
                                    <div className="flex flex-wrap gap-1">
                                        {vbqppl.keywords?.map((keyword, index) => (
                                            <Tag
                                                key={index}
                                                className="px-2 py-1 text-blue-600 border-blue-100 rounded-full bg-blue-50"
                                            >
                                                {keyword}
                                            </Tag>
                                        ))}
                                    </div>
                                </Descriptions.Item>
                            </Descriptions>
                        </Card>
                    </motion.div>
                </div>
            </div>
        </motion.div>
    );
}
