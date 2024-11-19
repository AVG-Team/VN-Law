import PropTypes from "prop-types";
import { useEffect, useState } from "react";
import TableApi from "~/api/law-service/tableApi";
import { Col, Pagination, Row, Card, Tag } from "antd";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTableList } from "@fortawesome/free-solid-svg-icons";

export default function Form(props) {
    const [page, setPage] = useState(0);
    const [pageSize, setPageSize] = useState(9);
    const [total, setTotal] = useState(0);
    const [content, setContent] = useState([]);
    const [isValueCategory, setIsValueCategory] = useState(false);
    const [nameFilter, setNameFilter] = useState("");
    const [categoryFilter, setCategoryFilter] = useState("");

    Form.propTypes = {
        title: PropTypes.string.isRequired,
    };

    const title = props.title;

    useEffect(() => {
        const fetchData = async () => {
            const { content, totalElements, size } = await TableApi.getAll({ page, pageSize });
            setContent(content);
            setTotal(Math.ceil(totalElements / size));
        };
        fetchData();
    }, [page, pageSize]);

    useEffect(() => {
        document.title = title || "Trang không tồn tại";
    }, [title]);

    return (
        <div className="px-10 py-8 lg:px-20">
            <div className="p-6 text-center bg-white border border-gray-300 rounded-lg">
                <p className="mb-2 text-2xl font-bold">
                    <FontAwesomeIcon icon={faTableList} className="mr-2" />
                    Danh sách các bảng biểu trong văn bản pháp luật
                </p>
                <p className="text-sm italic">*Bảng biểu được lấy ra từ các pháp điển*</p>
            </div>
            <Row gutter={[16, 16]} className="mt-5 !ml-0 !mr-0 rounded-lg border border-gray-300 bg-white p-6">
                {content.map((item) => (
                    <Col key={item.id} className="max-h-[300px]" span={6} sm={12} xs={24} md={12} lg={8}>
                        <Card
                            hoverable
                            onClick={() => window.open(`/vbqppl/${item.id}`, "_self")}
                            className="h-full overflow-hidden"
                            title={
                                <div style={{ display: "flex", flexDirection: "column" }}>
                                    <div className="flex justify-end">
                                        <Tag color="blue">Bảng biểu</Tag>
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
