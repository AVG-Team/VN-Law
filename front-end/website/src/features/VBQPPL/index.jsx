import PropTypes from "prop-types";
import { useEffect, useState } from "react";
import { Col, Pagination, Row, Card, Tag } from "antd";
import VbqpplApi from "~/api/law-service/vbqpplApi";

const categories = [
    { id: "1", name: "Luật" },
    { id: "2", name: "Nghị Định" },
    { id: "3", name: "Quyết Định" },
    { id: "4", name: "Thông Tư" },
    { id: "5", name: "Chính trị" },
];

const VBQPPL = (props) => {
    const [page, setPage] = useState(1); // Sửa từ 0 thành 1 vì API thường sử dụng trang bắt đầu từ 1
    const [pageSize, setPageSize] = useState(9);
    const [total, setTotal] = useState(0);
    const [content, setContent] = useState([]);
    const [type, setType] = useState("");

    // Xác nhận props
    VBQPPL.propTypes = {
        title: PropTypes.string.isRequired,
    };

    // Lấy tiêu đề từ props và đặt tiêu đề trang web
    const { title } = props;

    useEffect(() => {
        document.title = title || "Trang không tồn tại";
    }, [title]);

    // Xử lý khi người dùng thay đổi categoryFilter
    const handleCategoryChange = (value) => {
        setType(value);
        setPage(1); // Reset page to 1 when category changes
    };

    useEffect(() => {
        const fetchData = async () => {
            try {
                const { content, totalElements, size } = await VbqpplApi.filter({
                    type,
                    pageNo: page,
                    pageSize,
                });
                console.log(content);
                setContent(content);
                setTotal(Math.ceil(totalElements / size));
            } catch (error) {
                console.error("Error fetching data:", error);
            }
        };

        fetchData();
    }, [type, page, pageSize]);

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
                    value={type}
                    className="rounded-md border-0 p-1.5 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                    onChange={(e) => handleCategoryChange(e.target.value)}
                >
                    <option value="">Tìm kiếm theo thể loại...</option>
                    {categories.map((item) => (
                        <option key={item.id} value={item.name}>
                            {item.name}
                        </option>
                    ))}
                </select>
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
                        defaultCurrent={0}
                        current={page}
                        onChange={setPage}
                        pageSizeOptions={[6, 9]}
                        pageSize={pageSize}
                        onShowSizeChange={(current, size) => {
                            setPageSize(size);
                            setPage(0);
                        }}
                        total={total}
                    />
                </Col>
            </Row>
        </div>
    );
};

export default VBQPPL;
