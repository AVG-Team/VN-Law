import PropTypes from "prop-types";
import MarkdownIt from "markdown-it";
import { Card, Spin, Typography, Button, Space, Tooltip } from "antd";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux"; // Thêm useDispatch, useSelector
import articleApi from "~/services/articleApi";
import { updateChapterArticles } from "../../../services/redux/actions/treeLawAction"; // Import action
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
import { getById } from "../../../services/redux/actions/chapterAction"; // Import action

const { Title, Text } = Typography;
const md = new MarkdownIt({ html: true });
let loaded = false;

export default function Reader() {
    const [autoAnimateParent] = useAutoAnimate();
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);
    const [showScrollTop, setShowScrollTop] = useState(false);
    const [expanded, setExpanded] = useState(false);

    const dispatch = useDispatch();
    const selectedChapter = useSelector((state) => state.treelaw?.chapterSelected); // Lấy từ Redux
    const { chapter } = useSelector((state) => state.chapter);

    useEffect(() => {
        resetState();
    }, [selectedChapter]);

    useEffect(() => {
        const handleScroll = async () => {
            if (isBottomOfPage() && !loading) {
                setLoading(true);
                await fetchArticles();
                setLoading(false);
            }
            setShowScrollTop(window.scrollY > 300);
        };

        window.addEventListener("scroll", handleScroll);
        return () => window.removeEventListener("scroll", handleScroll);
    }, [selectedChapter, page, loading]);

    const resetState = () => {
        loaded = false;
        window.scrollTo(0, 0);
        setPage(1);
    };

    const isBottomOfPage = () => {
        const windowHeight = window.innerHeight;
        const scrollableHeight = document.body.scrollHeight;
        return window.scrollY + windowHeight >= scrollableHeight;
    };

    const fetchArticles = async () => {
        if (!selectedChapter?.id || loaded) return;

        try {
            const response = await articleApi.getAllByChapter(selectedChapter.id.toString(), page);
            const articles = response.data;
            if (!articles.content.length) {
                loaded = true;
                return;
            }
            dispatch(updateChapterArticles(articles.content));
            setPage((prevPage) => prevPage + 1);
        } catch (error) {
            console.error("Error fetching articles:", error);
        }
    };

    const handlePrint = () => {
        window.print();
    };

    useEffect(() => {
        if (selectedChapter?.id) {
            dispatch(getById(selectedChapter.id));
        }
    }, [selectedChapter?.id, dispatch]);

    const handleShare = () => {
        if (navigator.share && selectedChapter?.name) {
            navigator.share({
                title: chapter.data.name,
                text: "Xem nội dung pháp điển",
                url: window.location.href,
            });
        }
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
                            <BookOutlined className="text-xl text-blue-500" />
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
                                />
                            </Tooltip>
                            <Tooltip title="In">
                                <Button
                                    icon={<PrinterOutlined />}
                                    onClick={handlePrint}
                                    className="hover:text-blue-600"
                                    disabled={!selectedChapter?.articles?.length}
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
                                variant={false}
                                className="mb-4 transition-shadow hover:shadow-md"
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
                                                onClick={() => alert("Tóm tắt nội dung: " + article.name)} // Placeholder, thay bằng logic tóm tắt
                                            >
                                                <ProfileOutlined />
                                                Tóm tắt
                                            </Button>
                                            <Button
                                                size="small"
                                                type="text"
                                                className="hover:text-blue-600 rounded-4"
                                                onClick={() => setExpanded(!expanded)} // Toggle mở rộng/thu nhỏ
                                            >
                                                {expanded ? <MinusOutlined /> : <PlusOutlined />}
                                            </Button>
                                        </Space>
                                    </div>
                                }
                            >
                                <motion.div className="flex items-center justify-between mb-4 text-sm text-gray-500">
                                    <div
                                        id={article.id}
                                        className="markdown-body"
                                        dangerouslySetInnerHTML={{
                                            __html: expanded
                                                ? md.render(article.content) // Hiển thị toàn bộ nội dung khi mở rộng
                                                : md.render(article.content.substring(0, 500) + "..."), // Hiển thị 100 ký tự đầu tiên khi thu nhỏ
                                        }}
                                    />
                                    {article.tables?.map((table) => (
                                        <div
                                            key={table.id}
                                            className="mt-4 markdown-body"
                                            dangerouslySetInnerHTML={{ __html: md.render(table.html) }}
                                        />
                                    ))}
                                </motion.div>
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
                            />
                        </Tooltip>
                    </motion.div>
                )}
            </Card>
        </motion.div>
    );
}
