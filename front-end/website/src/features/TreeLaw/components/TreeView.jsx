import { Tree, Card, Typography, Input, Spin } from "antd";
import PropTypes from "prop-types";
import { useParams } from "react-router-dom";
import topicApi from "~/services/topicApi";
import React, { useEffect, useState } from "react";
import subjectApi from "~/services/subjectApi";
import chapterApi from "~/services/chapterApi";
import articleApi from "~/services/articleApi";
import { SearchOutlined, FolderOutlined, FileOutlined } from "@ant-design/icons";
import { motion } from "framer-motion";

const { Title } = Typography;
const { Search } = Input;

const updateTreeData = (list, key, children) =>
    list.map((node) => {
        if (node.key === key) {
            return { ...node, children };
        }
        if (node.children) {
            return { ...node, children: updateTreeData(node.children, key, children) };
        }
        return node;
    });

export default function TreeView({ setChapterSelected }) {
    TreeView.propTypes = {
        setChapterSelected: PropTypes.func,
    };

    const [treeData, setTreeData] = useState([]);
    const [loading, setLoading] = useState(false);
    const [searchText, setSearchText] = useState("");
    const [expandedKeys, setExpandedKeys] = useState([]);
    const [selectedKeys, setSelectedKeys] = useState([]);

    const { articleId } = useParams();
    const article = articleId;

    useEffect(() => {
        const fetchAllTopics = async () => {
            setLoading(true);
            try {
                const topicList = await topicApi.getAll();
                const data = topicList.data.map((topic) => ({
                    title: `Chủ đề ${topic.order}: ${topic.name}`,
                    key: `topic_${topic.id.toString()}`,
                    children: undefined,
                    icon: <FolderOutlined className="text-blue-500" />,
                }));
                setTreeData(data);
            } catch (error) {
                console.error("Error fetching topics:", error);
            } finally {
                setLoading(false);
            }
        };
        fetchAllTopics();
    }, []);

    useEffect(() => {
        const fetchArticleData = async () => {
            if (article && !loading) {
                setLoading(true);
                try {
                    const topicList = await topicApi.getAll();
                    const data = topicList.data.map((topic) => ({
                        title: `Chủ đề ${topic.order}: ${topic.name}`,
                        key: `topic_${topic.id.toString()}`,
                        children: undefined,
                        icon: <FolderOutlined className="text-blue-500" />,
                    }));
                    setTreeData(data);

                    const response = await articleApi.getTreeArticle(article);
                    const { topic, subject, chapter, articles } = response.data;
                    setChapterSelected({ id: chapter.id, name: chapter.name, articles });
                    const keyChapter = `chapter_${chapter.id}`;
                    const keySubject = `subject_${subject.id}`;
                    const keyTopic = `topic_${topic.id}`;

                    setExpandedKeys([keyTopic, keySubject, keyChapter]);
                    setSelectedKeys([keyChapter]);

                    await loadData({ key: keyTopic, name: topic.name });
                    await loadData({ key: keySubject, name: subject.name });
                } catch (error) {
                    console.error("Error fetching article data:", error);
                } finally {
                    setLoading(false);
                }
            }
        };
        fetchArticleData();
    }, [article, loading, setChapterSelected]);

    const onSelect = async (selectedKeys, info) => {
        if (selectedKeys.length === 0) return;
        setSelectedKeys(selectedKeys);
        const key = selectedKeys[0].split("_")[1];
        try {
            const res = await articleApi.getByChapterId(key);
            setChapterSelected({
                id: key,
                name: info.node.title,
                articles: res.data.content,
            });
        } catch (error) {
            console.error("Error fetching chapter data:", error);
        }
    };

    const loadData = async ({ key, name, children }) => {
        if (children) return;
        setExpandedKeys((origin) => [...origin, key]);
        setSelectedKeys([key]);

        try {
            if (key.startsWith("topic")) {
                const topicId = key.split("_")[1];
                const subjects = await subjectApi.getByTopic(topicId);
                const data = subjects.data.map((subject) => ({
                    title: `Đề mục ${subject.order}: ${subject.name}`,
                    key: `subject_${subject.id.toString()}`,
                    name: subject.name,
                    children: undefined,
                    icon: <FolderOutlined className="text-green-500" />,
                }));
                setTreeData((origin) => updateTreeData(origin, key, data));
            } else if (key.startsWith("subject")) {
                const subjectId = key.split("_")[1];
                const chapters = await chapterApi.getBySubject(subjectId);
                const data = chapters.data.map((chapter) => ({
                    title: `${chapter.name}`,
                    key: `chapter_${chapter.id.toString()}`,
                    children: undefined,
                    isLeaf: true,
                    name: chapter.name,
                    icon: <FileOutlined className="text-orange-500" />,
                }));
                setTreeData((origin) => updateTreeData(origin, key, data));
            }
        } catch (error) {
            console.error("Error loading tree data:", error);
        }
    };

    const onSearch = (value) => {
        setSearchText(value);
        // Implement search functionality
    };

    return (
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.5 }}>
            <Card className="h-full shadow-sm hover:shadow-md transition-shadow">
                <div className="mb-4">
                    <Title level={4} className="mb-4 text-center">
                        Mục lục Pháp Điển
                    </Title>
                    <Search
                        placeholder="Tìm kiếm trong mục lục..."
                        prefix={<SearchOutlined className="text-gray-400" />}
                        onChange={(e) => onSearch(e.target.value)}
                        className="mb-4"
                    />
                </div>
                <div className="relative">
                    {loading && (
                        <div className="absolute inset-0 bg-white bg-opacity-75 flex items-center justify-center z-10">
                            <Spin size="large" />
                        </div>
                    )}
                    <Tree
                        selectedKeys={selectedKeys}
                        expandedKeys={expandedKeys}
                        onSelect={onSelect}
                        loadData={loadData}
                        treeData={treeData}
                        height={600}
                        showLine
                        className="custom-tree"
                    />
                </div>
            </Card>
        </motion.div>
    );
}
