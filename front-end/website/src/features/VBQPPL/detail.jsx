import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Worker } from "@react-pdf-viewer/core";
import "@react-pdf-viewer/core/lib/styles/index.css";
import "@react-pdf-viewer/default-layout/lib/styles/index.css";
import { DocumentIcon, EyeIcon, ArrowLeftIcon } from "@heroicons/react/24/solid";
import Localization from "./components/Localization";
import { Breadcrumb, Typography, Card, Descriptions, Button, Space, Tag, Tooltip, Badge } from "antd";
import { ShareAltOutlined, PrinterOutlined, BookOutlined, LinkOutlined, HistoryOutlined } from "@ant-design/icons";
import { motion } from "framer-motion";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faScaleBalanced } from "@fortawesome/free-solid-svg-icons";
import { useDispatch, useSelector } from "react-redux";
import { filter, getById } from "../../services/redux/actions/vbqpplAction";
import html2canvas from "html2canvas";
import { jsPDF } from "jspdf";
import LoadingComponent from "../../components/ui/Loading";
import NoDataPage from "../../components/ui/NoData";
import ErrorPage from "../../components/ui/Error";

const { Title, Text } = Typography;

export default function Detail(props) {
    const dispatch = useDispatch();
    const { vbqppl, vbqppls, loading, error } = useSelector((state) => state.vbqppl);
    const [isViewPdf, setIsViewPdf] = useState(false);
    const [relatedDocs, setRelatedDocs] = useState([]);
    const navigate = useNavigate();
    let { param } = useParams();
    const vbqpplId = param;

    // Gọi API getById
    useEffect(() => {
        if (vbqpplId) {
            dispatch(getById(vbqpplId));
        }
    }, [vbqpplId, dispatch]);

    // Gọi API filter khi vbqppl.type có sẵn
    useEffect(() => {
        if (vbqppl?.type) {
            dispatch(
                filter({
                    pageNo: 0,
                    pageSize: 3,
                    type: vbqppl.type,
                }),
            );
        }
    }, [vbqppl, dispatch]);

    // Cập nhật relatedDocs từ vbqppls
    useEffect(() => {
        console.log("vbqppls ss", vbqppls);
        if (vbqppls && vbqppls.length > 0) {
            setRelatedDocs(vbqppls);
        }
    }, [vbqppls]);

    const handleViewPDF = () => {
        setIsViewPdf((prevIsViewPdf) => !prevIsViewPdf);
    };

    const handleDownload = async () => {
        if (!vbqppl?.html) {
            console.error("No HTML content available");
            return;
        }

        try {
            // Tạo một div tạm để render nội dung HTML
            const contentElement = document.createElement("div");
            contentElement.innerHTML = vbqppl.html;
            contentElement.style.position = "absolute";
            contentElement.style.left = "-9999px"; // Ẩn khỏi giao diện
            document.body.appendChild(contentElement);

            // Chuyển HTML thành hình ảnh bằng html2canvas
            const canvas = await html2canvas(contentElement, {
                scale: 2, // Tăng chất lượng hình ảnh
                useCORS: true, // Hỗ trợ hình ảnh từ domain khác
                logging: true, // Bật log để debug
            });
            const imgData = canvas.toDataURL("image/png");

            // Tạo PDF bằng jsPDF
            const pdf = new jsPDF("p", "mm", "a4"); // Kích thước A4, hướng dọc
            const imgProps = pdf.getImageProperties(imgData);
            const pdfWidth = pdf.internal.pageSize.getWidth();
            const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;

            // Thêm hình ảnh vào PDF và xử lý đa trang
            let heightLeft = pdfHeight;
            let position = 0;

            pdf.addImage(imgData, "PNG", 0, position, pdfWidth, pdfHeight);
            heightLeft -= pdf.internal.pageSize.getHeight();

            while (heightLeft > 0) {
                position = heightLeft - pdfHeight;
                pdf.addPage();
                pdf.addImage(imgData, "PNG", 0, position, pdfWidth, pdfHeight);
                heightLeft -= pdf.internal.pageSize.getHeight();
            }

            // Tải xuống PDF
            pdf.save(`vbqppl_${vbqpplId}.pdf`);

            // Dọn dẹp
            document.body.removeChild(contentElement);
        } catch (error) {
            console.error("Error generating PDF:", error);
        }
    };

    const handlePrint = () => {
        window.print();
    };

    const handleShare = () => {
        if (navigator.share) {
            navigator.share({
                title: vbqppl?.title || "Văn bản QPPL",
                text: vbqppl?.description || "",
                url: window.location.href,
            });
        }
    };

    const handleStatusDocument = (status) => {
        switch (status) {
            case 1:
                return <Badge status="error" text="Hết hiệu lực toàn bộ" />;
            case 2:
                return <Badge status="warning" text="Hết hiệu lực một phần" />;
            case 3:
                return <Badge status="success" text="Đang hiệu lực" />;
        }
    };

    if (loading)
        return <LoadingComponent fullscreen={false} title="Đang tải văn bản quy phạm pháp luật..." size="large" />;
    if (error === "Network Error")
        return (
            <ErrorPage
                errorCode="500"
                title="Đã xảy ra lỗi"
                description="Xin lỗi, có lỗi xảy ra với hệ thống"
                onRetry={() => window.location.reload()}
                onGoHome={() => (window.location.href = "/")}
            />
        );
    if (error === "Page not found")
        return (
            <ErrorPage
                errorCode="404"
                title="Trang không tồn tại"
                description="Xin lỗi, trang bạn đang tìm kiếm không tồn tại hoặc đã bị xóa"
                onGoHome={() => (window.location.href = "/")}
                onGoBack={() => window.history.back()}
                showBackButton={true}
            />
        );
    if (!vbqppl)
        return (
            <NoDataPage
                title="Không có dữ liệu VBQPPL"
                description="Hiện tại chưa có dữ liệu VBQPPL để hiển thị"
                showRefreshButton={true}
                onRefresh={() => window.location.reload()}
            />
        );

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
                    { title: "Văn bản quy phạm pháp luật", href: "/van-ban-quy-pham-phap-luat" },
                    { title: vbqppl.title || "Chi tiết văn bản" },
                ]}
                className="mb-6"
            />

            <div className="flex items-center justify-between p-4 mb-6 bg-white rounded-lg shadow-sm">
                <div className="flex items-center space-x-4">
                    <Button
                        type="text"
                        icon={<ArrowLeftIcon className="w-4 h-4" />}
                        onClick={() => navigate(-1)}
                        className="hover:text-blue-600"
                    >
                        Quay lại
                    </Button>
                    {handleStatusDocument(vbqppl.status)}
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
                            <div className="flex items-center mb-4 underscore">
                                <FontAwesomeIcon icon={faScaleBalanced} className="mr-3 text-2xl text-blue-600" />
                                <Title level={2} className="!mb-0 ">
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
                                        {vbqppl.issue_date
                                            ? new Date(vbqppl.issue_date).toLocaleDateString("vi-VN")
                                            : "N/A"}
                                    </span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Cơ quan ban hành">
                                    <span className="font-medium">{vbqppl.issuer || "N/A"}</span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Trạng thái">
                                    {handleStatusDocument(vbqppl.status)}
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
                            {relatedDocs.length > 0 ? (
                                relatedDocs.map((doc) => (
                                    <div
                                        key={doc.id}
                                        className="p-2 mb-4 transition-colors rounded-lg last:mb-0 hover:bg-gray-50 hover:text-blue-600"
                                    >
                                        <a
                                            href={`/van-ban-quy-pham-phap-luat/${doc.id}`}
                                            className="block transition-colors hover:text-blue-600"
                                        >
                                            <Text className="block font-medium">{doc.title}</Text>
                                            <Text type="secondary" className="text-sm">
                                                {doc.number} -{" "}
                                                {doc.issue_date
                                                    ? new Date(doc.issue_date).toLocaleDateString("vi-VN")
                                                    : "N/A"}
                                            </Text>
                                        </a>
                                    </div>
                                ))
                            ) : (
                                <Text type="secondary">Không có văn bản liên quan</Text>
                            )}
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
                                        {vbqppl.effective_date
                                            ? new Date(vbqppl.effective_date).toLocaleDateString("vi-VN")
                                            : "N/A"}
                                    </span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Ngày hết hiệu lực">
                                    <span className="font-medium">
                                        {vbqppl.expiryDate
                                            ? new Date(vbqppl.effective_end_date).toLocaleDateString("vi-VN")
                                            : "Chưa có"}
                                    </span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Lĩnh vực">
                                    <span className="font-medium">{vbqppl.type || "N/A"}</span>
                                </Descriptions.Item>
                                <Descriptions.Item label="Từ khóa">
                                    <div className="flex flex-wrap gap-1">
                                        {vbqppl.keywords?.length > 0 ? (
                                            vbqppl.keywords.map((keyword, index) => (
                                                <Tag
                                                    key={index}
                                                    className="px-2 py-1 text-blue-600 border-blue-100 rounded-full bg-blue-50"
                                                >
                                                    {keyword}
                                                </Tag>
                                            ))
                                        ) : (
                                            <Text type="secondary">Không có</Text>
                                        )}
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
