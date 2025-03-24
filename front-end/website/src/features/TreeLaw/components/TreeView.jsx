import { Tree } from "antd";
import PropTypes from "prop-types";
import { Card } from "@mui/material";
import { useParams } from "react-router-dom";
import topicApi from "~/services/topicApi";
import React, { useEffect, useState } from "react";
import subjectApi from "~/services/subjectApi";
import chapterApi from "~/services/chapterApi";
import articleApi from "~/services/articleApi";

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

    const [expandedKeys, setExpandedKeys] = useState([]);
    const [selectedKeys, setSelectedKeys] = useState([]);

    const { articleId } = useParams();
    const article = articleId;

    useEffect(() => {
        const fetchAllTopics = async () => {
            const topicList = await topicApi.getAll();
            console.log(topicList);
            const data = topicList.data.map((topic) => {
                return {
                    title: `Chủ đề ${topic.order}: ${topic.name}`,
                    key: `topic_${topic.id.toString()}`,
                    children: undefined,
                };
            });
            setTreeData(data);
        };
        fetchAllTopics();
    }, []);

    useEffect(() => {
        const fetchArticleData = async () => {
            if (article && !loading) {
                setLoading(true);
                const topicList = await topicApi.getAll();
                const data = topicList.data.map((topic) => ({
                    title: `Chủ đề ${topic.order}: ${topic.name}`,
                    key: `topic_${topic.id.toString()}`,
                    children: undefined,
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

                setLoading(false);
            }
        };
        fetchArticleData();
    }, [article, loading, setChapterSelected]);

    const onSelect = async (selectedKeys, info) => {
        if (selectedKeys.length === 0) return;
        setSelectedKeys(selectedKeys);
        const key = selectedKeys[0].split("_")[1];
        const res = await articleApi.getByChapterId(key);
        setChapterSelected({
            id: key,
            name: info.node.title,
            articles: res.data.content,
        });
    };

    const loadData = async ({ key, name, children }) => {
        if (children) return;
        setExpandedKeys((origin) => [...origin, key]);
        setSelectedKeys([key]);

        if (key.startsWith("topic")) {
            const topicId = key.split("_")[1];
            const subjects = await subjectApi.getByTopic(topicId);
            const data = subjects.data.map((subject) => ({
                title: `Đề mục ${subject.order}: ${subject.name}`,
                key: `subject_${subject.id.toString()}`,
                name: subject.name,
                children: undefined,
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
            }));
            setTreeData((origin) => updateTreeData(origin, key, data));
        }
    };
    return (
        <div className="ml-5 position-sticky">
            <Card className="h-full ml-2 border border-slate-200">
                <div className="text-center border-b-2 border-slate-200">
                    <h3 className="my-3 ml-2 font-semibold">Mục lục Pháp Điển</h3>
                </div>
                <Tree
                    selectedKeys={selectedKeys}
                    expandedKeys={expandedKeys}
                    onSelect={onSelect}
                    loadData={loadData}
                    treeData={treeData}
                    height={600}
                    showLine
                />
            </Card>
        </div>
    );
}
