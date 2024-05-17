import TreeView from "./components/TreeView";
import Reader from "./components/Reader";
import { useState } from "react";
import { Col, Row } from "antd";

export default function TreeLaw() {
    const [chapterSelected, setChapterSelected] = useState(null);
    return (
        <main>
            <Row gutter={[16, 16]} className="my-5">
                <Col sm={24} md={24} lg={8} span={6}>
                    <TreeView setChapterSelected={setChapterSelected} />
                </Col>
                <Col sm={24} md={24} lg={16} span={18}>
                    <Reader selectedChapter={chapterSelected} setChapterSelected={setChapterSelected} />
                </Col>
            </Row>
        </main>
    );
}
