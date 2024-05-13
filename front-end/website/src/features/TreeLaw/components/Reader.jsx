import { Card, Spin, Input } from "antd";
import { useEffect, useState } from "react";
import MarkdownIt from "markdown-it";
import { useAutoAnimate } from "@formkit/auto-animate/react";
import articleApi from "~/api/law-service/articleApi";

const { Search } = Input;
const md = new MarkdownIt({ html: true });
let loaded = false;

const ReaderProps = {
    selectedChuong: null, // Khởi tạo bằng giá trị mặc định tùy ý
    setSelectedChuong: null, // Khởi tạo bằng giá trị mặc định tùy ý
};
export default function Reader({
    selectedChapter = ReaderProps.selectedChuong,
    setSeletedChapter = ReaderProps.setSelectedChuong,
}) {
    const [autoAnimateParent] = useAutoAnimate();
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        loaded = false;
        window.scrollTo(0, 0);
        setPage(1);
    }, [selectedChapter]);

    useEffect(() => {
        async function fetchAll() {
            if (!selectedChapter.id || loaded) return;
            const articles = await articleApi.getAllByChapter(selectedChapter.id.toString(), page);
            if (!articles.content.length) {
                loaded = true;
                return;
            }
            setSeletedChapter({
                ...selectedChapter,
                articles: [...selectedChapter.articles, ...articles.content],
            });
            setPage(page + 1);
        }

        let isFetching = false;
        async function handleScroll() {
            const windowHeight = window.innerHeight;
            const scrollableHeight = document.body.scrollHeight;

            if (window.scrollY + windowHeight >= scrollableHeight) {
                if (isFetching) return;
                isFetching = true;
                setLoading(true);
                await fetchAll();
                setLoading(false);
                isFetching = false;
            }
        }
        window.addEventListener("scroll", handleScroll);
        return () => window.removeEventListener("scroll", handleScroll);
    }, [selectedChapter, page, setSeletedChapter]);
    return (
        <Card style={{ marginRight: 20 }}>
            <div
                style={{
                    position: "sticky",
                    top: 0,
                    zIndex: 1,
                    backgroundColor: "white",
                    padding: 12,
                    borderBottom: "2px solid #f0f0f0",
                    borderRadius: 4,
                }}
            >
                <Search placeholder="Tìm kiếm một điều mục..." loading={loading} />
                {/* <h1 style={{ textAlign: "center" }}>{selectedChapter.title}</h1> */}
            </div>
            <div style={{ scrollBehavior: "smooth" }} ref={autoAnimateParent}>
                {selectedChapter?.articles?.map((article) => {
                    return (
                        <Card
                            bordered={false}
                            style={{ boxShadow: "unset" }}
                            key={article.id}
                            title={
                                <div className="flex items-center justify-between">
                                    {article.name}
                                    {/* <Button
                                        onClick={() => classify(article.content)}
                                        type="primary"
                                        icon={<ReadOutlined />}
                                    >
                                        Tóm tắt
                                    </Button> */}
                                </div>
                            }
                        >
                            <div id={article.id} dangerouslySetInnerHTML={{ __html: md.render(article.content) }}></div>
                            {article.tables?.map((table) => {
                                return (
                                    <div
                                        className="markdown-body"
                                        key={table.id}
                                        dangerouslySetInnerHTML={{ __html: md.render(table.html) }}
                                    ></div>
                                );
                            })}
                        </Card>
                    );
                })}
            </div>
            {loading && (
                <div className="flex justify-center w-full">
                    <Spin size="large"></Spin>
                </div>
            )}
        </Card>
    );
}
