import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { Card, Spin, Typography, Button, Space, Tooltip, Modal, notification } from "antd";
import MarkdownIt from "markdown-it";
import DOMPurify from "dompurify"; // For sanitizing HTML
import { useAutoAnimate } from "@formkit/auto-animate/react";
import { motion } from "framer-motion";
import {
    ShareAltOutlined,
    PrinterOutlined,
    BookOutlined,
    ArrowUpOutlined,
    PlusOutlined,
    MinusOutlined,
    ProfileOutlined,
} from "@ant-design/icons";
import articleApi from "~/services/articleApi";
import { updateChapterArticles } from "../../../services/redux/actions/treeLawAction";
import { getById } from "../../../services/redux/actions/chapterAction";
import { summaryDocumentRequest } from "../../../services/redux/actions/summaryAction";

const { Title, Text } = Typography;
const md = new MarkdownIt({ html: true });

export default function Reader() {
    const [autoAnimateParent] = useAutoAnimate();
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);
    const [showScrollTop, setShowScrollTop] = useState(false);
    const [expanded, setExpanded] = useState(false);
    const [showModal, setShowModal] = useState(false);
    const [isLoaded, setIsLoaded] = useState(false); // Replace global `loaded` with state

    const dispatch = useDispatch();
    const selectedChapter = useSelector((state) => state.treelaw?.chapterSelected);
    const { chapter, loading: chapterLoading } = useSelector((state) => state.chapter);
    const { summary_document, loading: summaryLoading, error: summaryError } = useSelector((state) => state.summary);

    useEffect(() => {
        resetState();
    }, [selectedChapter]);

    useEffect(() => {
        const handleScroll = async () => {
            if (isBottomOfPage() && !loading && !isLoaded) {
                setLoading(true);
                await fetchArticles();
                setLoading(false);
            }
            setShowScrollTop(window.scrollY > 300);
        };

        window.addEventListener("scroll", handleScroll);
        return () => window.removeEventListener("scroll", handleScroll);
    }, [selectedChapter, page, loading, isLoaded]);

    useEffect(() => {
        if (selectedChapter?.id) {
            dispatch(getById(selectedChapter.id));
        }
    }, [selectedChapter?.id, dispatch]);

    useEffect(() => {
        let modalInstance = null;
        if (showModal) {
            if (summary_document) {
                modalInstance = Modal.info({
                    title: (
                        <Title level={4} style={{ color: "#1677ff", marginBottom: 0 }}>
                            📝 Tóm tắt tài liệu
                        </Title>
                    ),
                    content: (
                        <div style={{ marginTop: 16, maxHeight: "50vh", overflowY: "auto" }}>
                            {summaryLoading ? (
                                <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                                    <div
                                        style={{
                                            width: 20,
                                            height: 20,
                                            border: "3px solid #1677ff",
                                            borderTop: "3px solid transparent",
                                            borderRadius: "50%",
                                            animation: "spin 1s linear infinite",
                                        }}
                                    />
                                    <Text style={{ fontSize: 16, color: "#555" }}>
                                        Đang tạo tóm tắt, vui lòng chờ...
                                    </Text>
                                </div>
                            ) : (
                                <Text style={{ fontSize: 16, color: "#333", whiteSpace: "pre-line", lineHeight: 1.6 }}>
                                    {summary_document || "Không có nội dung tóm tắt."}
                                </Text>
                            )}
                        </div>
                    ),
                    okText: "Đóng",
                    width: 700, // 👈 tăng chiều rộng modal
                    centered: true,
                    maskClosable: false,
                    onOk: () => setShowModal(false),
                });
            } else if (summaryError) {
                modalInstance = Modal.error({
                    title: "Lỗi",
                    content: <Text>{summaryError || "Không thể tạo tóm tắt. Vui lòng thử lại."}</Text>,
                    onOk: () => setShowModal(false),
                });
            }
        }

        return () => {
            if (modalInstance) modalInstance.destroy();
        };
    }, [showModal, summary_document, summaryLoading, summaryError]);

    const resetState = () => {
        setIsLoaded(false);
        window.scrollTo(0, 0);
        setPage(1);
    };

    const isBottomOfPage = () => {
        const windowHeight = window.innerHeight;
        const scrollableHeight = document.body.scrollHeight;
        return window.scrollY + windowHeight >= scrollableHeight;
    };

    const fetchArticles = async () => {
        if (!selectedChapter?.id || isLoaded) return;

        try {
            const response = await articleApi.getAllByChapter(selectedChapter.id.toString(), page);
            const articles = response.data;
            if (!articles.content.length) {
                setIsLoaded(true);
                return;
            }
            dispatch(updateChapterArticles(articles.content));
            setPage((prevPage) => prevPage + 1);
        } catch (error) {
            console.error("Error fetching articles:", error);
            notification.error({
                message: "Lỗi",
                description: "Không thể tải bài viết. Vui lòng thử lại.",
            });
        }
    };

    const handlePrint = () => {
        window.print();
    };

    const handleShare = () => {
        if (navigator.share && selectedChapter?.name) {
            navigator
                .share({
                    title: chapter?.data.name,
                    text: "Xem nội dung pháp điển",
                    url: window.location.href,
                })
                .catch((error) => {
                    console.error("Share failed:", error);
                    notification.info({
                        message: "Chia sẻ không thành công",
                        description: "Vui lòng sao chép liên kết thủ công.",
                    });
                });
        } else {
            navigator.clipboard.writeText(window.location.href).then(() => {
                notification.success({
                    message: "Đã sao chép liên kết",
                    description: "Liên kết đã được sao chép vào clipboard.",
                });
            });
        }
    };

    const handleSummaryDocument = (document) => {
        if (!document) {
            notification.error({
                message: "Lỗi",
                description: "Không có nội dung để tóm tắt.",
            });
            return;
        }
        dispatch(summaryDocumentRequest({ document }));
        setShowModal(true);
    };

    const scrollToTop = () => {
        window.scrollTo({ top: 0, behavior: "smooth" });
    };

    return (
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.5 }}>
            <Card className="transition-shadow shadow-sm hover:shadow-md">
                <div
                    className="sticky top-0 z-10 bg-white border-b border-gray-100 rounded-t-lg"
                    style={{ margin: "-24px -24px 24px -24px", padding: "16px 24px" }}
                >
                    <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-2">
                            <BookOutlined className="text-xl text-blue-500" aria-hidden="true" />
                            <Title level={4} className="!mb-0">
                                {chapter?.data.name || "Chọn một mục để xem nội dung"}
                            </Title>
                        </div>
                        <Space>
                            <Tooltip title="Chia sẻ">
                                <Button
                                    icon={<ShareAltOutlined />}
                                    onClick={handleShare}
                                    className="hover:text-blue-600"
                                    disabled={!selectedChapter?.name}
                                    aria-label="Chia sẻ nội dung"
                                />
                            </Tooltip>
                            <Tooltip title="In">
                                <Button
                                    icon={<PrinterOutlined />}
                                    onClick={handlePrint}
                                    className="hover:text-blue-600"
                                    disabled={!selectedChapter?.articles?.length}
                                    aria-label="In nội dung"
                                />
                            </Tooltip>
                        </Space>
                    </div>
                </div>

                <div className="prose prose-lg max-w-none" style={{ scrollBehavior: "smooth" }} ref={autoAnimateParent}>
                    {selectedChapter?.articles?.map((article, index) => (
                        <motion.div
                            key={article.id}
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ duration: 0.5, delay: index * 0.1 }}
                        >
                            <Card
                                hoverable
                                className="mb-4 transition-shadow"
                                title={
                                    <div className="flex items-center justify-between">
                                        <Text strong className="text-lg">
                                            {article.name}
                                        </Text>
                                        <Space>
                                            <Button
                                                size="small"
                                                type="text"
                                                className="p-3 rounded-full hover:text-blue-600"
                                                onClick={() => handleSummaryDocument(article.content)}
                                                aria-label={`Tóm tắt bài viết ${article.name}`}
                                            >
                                                <ProfileOutlined />
                                                Tóm tắt
                                            </Button>
                                            <Button
                                                size="small"
                                                type="text"
                                                className="rounded-full hover:text-blue-600"
                                                onClick={() => setExpanded(!expanded)}
                                                aria-label={expanded ? "Thu nhỏ nội dung" : "Mở rộng nội dung"}
                                            >
                                                {expanded ? <MinusOutlined /> : <PlusOutlined />}
                                            </Button>
                                        </Space>
                                    </div>
                                }
                            >
                                <div className="flex items-center justify-between mb-4 text-sm text-gray-500">
                                    <div
                                        id={article.id}
                                        className="markdown-body"
                                        dangerouslySetInnerHTML={{
                                            __html: DOMPurify.sanitize(
                                                expanded
                                                    ? md.render(article.content)
                                                    : md.render(article.content.substring(0, 500) + "..."),
                                            ),
                                        }}
                                    />
                                    {article.tables?.map((table) => (
                                        <div
                                            key={table.id}
                                            className="mt-4 markdown-body"
                                            dangerouslySetInnerHTML={{
                                                __html: DOMPurify.sanitize(md.render(table.html)),
                                            }}
                                        />
                                    ))}
                                </div>
                            </Card>
                        </motion.div>
                    ))}
                </div>
                {loading && (
                    <div className="flex justify-center w-full py-8">
                        <Spin size="large" />
                    </div>
                )}

                {showScrollTop && (
                    <motion.div
                        initial={{ opacity: 0, scale: 0.8 }}
                        animate={{ opacity: 1, scale: 1 }}
                        transition={{ duration: 0.2 }}
                        className="fixed z-50 bottom-8 right-8"
                    >
                        <Tooltip title="Lên đầu trang">
                            <Button
                                type="primary"
                                shape="circle"
                                icon={<ArrowUpOutlined />}
                                onClick={scrollToTop}
                                className="transition-shadow shadow-lg hover:shadow-xl"
                                aria-label="Cuộn lên đầu trang"
                            />
                        </Tooltip>
                    </motion.div>
                )}
            </Card>
        </motion.div>
    );
}
