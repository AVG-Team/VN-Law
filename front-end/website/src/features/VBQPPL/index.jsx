import PropTypes from "prop-types";
import { useEffect, useState } from "react";
import VbqpplApi from "~/api/law-service/vbqpplApi";
import { Col, Pagination, Row, Card, Tag } from "antd";

export default function VBQPPL(props) {
    const [page, setPage] = useState(0);
    const [pageSize, setPageSize] = useState(9);
    const [total, setTotal] = useState(0);
    const [content, setContent] = useState([]);
    const [isValueCategory, setIsValueCategory] = useState(false);
    const [nameFilter, setNameFilter] = useState("");
    const [categoryFilter, setCategoryFilter] = useState("");

    VBQPPL.propTypes = {
        title: PropTypes.string.isRequired,
    };

    const title = props.title;

    useEffect(() => {
        const fetchData = async () => {
            const { content, totalElements, size } = await VbqpplApi.getAllByPage({ page, pageSize });
            setContent(content);
            setTotal(Math.ceil(totalElements / size));
        };
        fetchData();
    }, [page, pageSize]);

    useEffect(() => {
        document.title = title || "Trang không tồn tại";
    }, [title]);

    const categories = [
        { id: "1", name: "Luật" },
        { id: "2", name: "Nghị Định" },
        { id: "3", name: "Quyết Định" },
        { id: "4", name: "Thông Tư" },
        { id: "5", name: "Thông Tư Liên Tịch" },
        { id: "6", name: "Chính trị" },
    ];

    const filteredContent = content.filter((item) => {
        const matchesName = item.title;
        if (categoryFilter === "-1") return matchesName;
        const matchesCategory =
            categoryFilter === "" || getCategoryNameById(categoryFilter).toLowerCase() === item.category.toLowerCase();
        return matchesName && matchesCategory;
    });

    const getCategoryNameById = (categoryId) => {
        const category = categories.find((cat) => cat.id === categoryId);
        return category ? category.name : "Văn bản khác";
    };

    const handleCategoryChange = (value) => {
        setCategoryFilter(value);
        setIsValueCategory(value !== "-1");
    };

    return (
        <div className="px-10 py-8 lg:px-20">
            <div>
                <p className="text-2xl font-bold">Xem danh sách các văn bản quy phạm pháp luật</p>
                <p className="text-sm italic">
                    *Nhiều văn bản pháp luật hiện nay vẫn chưa được pháp điển hoá cụ thể. Dưới đây là chỉ sự sắp xếp
                    nhưng văn bản đó do hệ thống tự tính toán, không phải chính thức từ chính chủ*
                </p>
            </div>
            <div className="grid grid-cols-2 gap-2 mt-3 lg:grid-cols-3 lg:gap-4">
                <select
                    name="category"
                    id="search_category"
                    value={categoryFilter}
                    className={`rounded-md border-0 p-1.5 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 ${
                        isValueCategory ? "text-gray-900" : "text-gray-400"
                    }`}
                    onChange={handleCategoryChange}
                >
                    <option value="-1" className="text-gray-400">
                        Tìm kiếm theo thể loại...
                    </option>
                    {categories.map((item) => (
                        <option key={item.id} value={item.id} className="text-gray-900">
                            {item.name}
                        </option>
                    ))}
                </select>
                <input
                    name="name"
                    id="search_name"
                    placeholder="Tìm kiếm theo tên..."
                    value={nameFilter}
                    onChange={(e) => setNameFilter(e.target.value)}
                    className="rounded-md border-0 p-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                />
            </div>
            <Row gutter={[16, 16]} className="mt-5">
                {content.map((item) => (
                    <Col key={item.id} className="max-h-[300px]" span={6} sm={12} xs={24} md={12} lg={8}>
                        <Card
                            hoverable
                            onClick={() => window.open(`/vbqppl/${item.id}`, "_self")}
                            className="h-full overflow-hidden"
                            title={
                                <div style={{ display: "flex", flexDirection: "column" }}>
                                    <div className="flex justify-end">
                                        <Tag color="blue">{item.type}</Tag>
                                    </div>
                                </div>
                            }
                        >
                            <div dangerouslySetInnerHTML={{ __html: item.html }}></div>
                        </Card>
                    </Col>
                ))}
            </Row>
            <Row justify="end">
                <Col className="flex justify-center mt-5" span={24}>
                    <Pagination
                        defaultCurrent={1}
                        current={page}
                        onChange={(page, size) => {
                            setPage(page);
                            setPageSize(size);
                        }}
                        pageSizeOptions={[6, 9]}
                        pageSize={pageSize}
                        total={total}
                        showSizeChanger
                    />
                </Col>
            </Row>
        </div>
    );
}
