import { Card } from "@mui/material";
import { Tree } from "antd";
import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import topicApi from "~/api/law-service/topicApi";
import subjectApi from "~/api/law-service/subjectApi";
import chapterApi from "~/api/law-service/chapterApi";
import articleApi from "~/api/law-service/articleApi";

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
    const [treeData, setTreeData] = useState([]);
    const [loading, isLoading] = useState(false);

    const [expandedKeys, setExpandedKeys] = useState([]);
    const [selectedKeys, setSelectedKeys] = useState([]);

    const { articleId } = useParams();
    const article = articleId;

    useEffect(() => {
        async function fetchAllTopic() {
            const topicList = await topicApi.getAll();
            const data = topicList.map((topic) => {
                return {
                    title: `Chủ đề ${topic.order}: ${topic.name}`,
                    key: `topic_${topic.id.toString()}`,
                    children: undefined,
                };
            });
            setTreeData(data);
        }
        fetchAllTopic();
    }, []);

    useEffect(() => {
        async function getArticle() {
            if (article && !loading) {
                isLoading(true);
                const topicList = await topicApi.getAll();
                const data = topicList.map((topic) => {
                    return {
                        title: `Chủ đề ${topic.order}: ${topic.name}`,
                        key: `topic_${topic.id.toString()}`,
                        children: undefined,
                    };
                });
                setTreeData(data);

                const { topic, subject, chapter, articles } = await articleApi.getTreeArticle(article);
                setChapterSelected({
                    id: chapter.id,
                    name: chapter.name,
                    articles: articles,
                });
                const keyChapter = `chapter_${chapter.id}`;
                const keySubject = `subject_${subject.id}`;
                const keyTopic = `topic_${topic.id}`;

                setExpandedKeys([keyTopic, keySubject, keyChapter]);
                setSelectedKeys([keyChapter]);
                await onloadeddata({
                    key: `topic_${topic.id}`,
                    ten: topic.name,
                    children: undefined,
                });

                await onloadeddata({
                    key: `subject_${subject.id}`,
                    ten: subject.name,
                    children: undefined,
                });

                loading(false);
            }
        }
        getArticle();
    }, [article, loading, setChapterSelected]);

    const onSelect = async (selectedKeys, info) => {
        if (selectedKeys.length === 0) return;
        setSelectedKeys(selectedKeys);
        const key = selectedKeys[0].toString().split("_")[1].toString();
        articleApi.getByChapterId(key).then((res) => {
            setChapterSelected({
                id: key,
                name: info.node.title,
                articles: res.content,
            });
        });
    };

    const loadData = async ({ key, name, children }) => {
        new Promise((resolve) => {
            if (children) {
                resolve();
                return;
            }
            setExpandedKeys((origin) => [...origin, key]);
            setSelectedKeys([key]);

            if (key.startsWith("topic")) {
                const topicId = key.split("_")[1];
                subjectApi.getByTopic(topicId).then((subjects) => {
                    const data = subjects.map((subject) => {
                        return {
                            title: `Đề mục ${subject.order}: ${subject.name}`,
                            key: `subject_${subject.id.toString()}`,
                            name: subject.name,
                            children: undefined,
                        };
                    });
                    setTreeData((origin) => updateTreeData(origin, key, data));
                    resolve();
                });
            } else if (key.startsWith("subject")) {
                const subjectId = key.split("_")[1];
                chapterApi.getBySubject(subjectId).then((chapters) => {
                    const data = chapters.map((chapter) => {
                        return {
                            title: ` ${chapter.name}`,
                            key: `chapter_${chapter.id.toString()}`,
                            children: undefined,
                            isleaf: true,
                            name: chapter.name,
                        };
                    });
                    console.log(data.children);
                    setTreeData((origin) => updateTreeData(origin, key, data));
                    resolve();
                });
            }
        });
    };
    return (
        <div className="mt-2 ml-5 position-sticky">
            <Card className="h-full ml-2 border border-slate-200">
                <div className="text-center border-b-2 border-slate-200">
                    <h3 className="my-3 ml-2 font-semibold ">Mục lục Pháp Điển</h3>
                </div>
                <Tree
                    selectedKeys={selectedKeys}
                    expandedKeys={expandedKeys}
                    onSelect={onSelect}
                    loadData={loadData}
                    treeData={treeData}
                    height={570}
                    showLine
                />
            </Card>
        </div>
    );
}
