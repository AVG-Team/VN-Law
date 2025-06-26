import { Tree, Card, Typography, Input, Spin } from "antd";
import PropTypes from "prop-types";
import { useParams } from "react-router-dom";
import React, { useEffect, useState } from "react";
import { SearchOutlined, FolderOutlined, FileOutlined } from "@ant-design/icons";
import { motion } from "framer-motion";
import { useDispatch, useSelector } from "react-redux";
import {
    fetchArticleTreeRequest,
    fetchChapterDataRequest,
    fetchTopicsRequest,
    loadTreeDataRequest,
    setExpandedKeys,
    setSelectedKeys,
} from "../../../services/redux/actions/treeLawAction";
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
const getIcon = (iconType) => {
    switch (iconType) {
        case "folder":
            return <FolderOutlined className="text-blue-500" />;
        case "file":
            return <FileOutlined className="text-orange-500" />;
        default:
            return null;
    }
};

const filterTreeData = (data, searchText) => {
    return data
        .map((node) => {
            const children = node.children ? filterTreeData(node.children, searchText) : [];
            if (node.title.toLowerCase().includes(searchText.toLowerCase()) || children.length > 0) {
                return { ...node, children };
            }
            return null;
        })
        .filter((node) => node !== null);
};

export default function TreeView({ setChapterSelected }) {
    TreeView.propTypes = {
        setChapterSelected: PropTypes.func,
    };

    const dispatch = useDispatch();
    const { treeData, loading, expandedKeys, selectedKeys, chapterSelected } = useSelector((state) => state.treelaw);
    const [searchText, setSearchText] = useState("");
    const [searchKeyword, setSearchKeyword] = useState("");
    const { articleId } = useParams();
    const article = articleId;
    const filteredTreeData = searchKeyword ? filterTreeData(treeData, searchKeyword) : treeData;

    useEffect(() => {
        console.log("Dispatching fetchTopicsRequest");
        dispatch(fetchTopicsRequest());
    }, [dispatch]);

    useEffect(() => {
        if (article) {
            console.log("Dispatching fetchArticleTreeRequest with article:", article);
            dispatch(fetchArticleTreeRequest(article));
        } else {
            console.log("No articleId found, skipping fetchArticleTreeRequest");
        }
    }, [article, dispatch]);

    const onSelect = async (selectedKeys, info) => {
        if (selectedKeys.length === 0) return;
        dispatch(setSelectedKeys(selectedKeys));
        const key = selectedKeys[0].split("_")[1];
        dispatch(fetchChapterDataRequest(key));
    };

    const loadData = async ({ key, name }) => {
        console.log("Loading data for key:", key, "name:", name);
        dispatch(loadTreeDataRequest(key, name));
        dispatch(setExpandedKeys([...expandedKeys, key]));
        dispatch(setSelectedKeys([key]));
        return new Promise((resolve) => resolve());
    };

    const onSearchChange = (e) => {
        setSearchText(e.target.value);
    };

    const onSearch = () => {
        setSearchKeyword(searchText);
    };

    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="flex flex-col h-fit "
        >
            <Card className="flex-1 overflow-hidden transition-shadow shadow-sm hover:shadow-md">
                <div className="mb-4">
                    <Title level={4} className="mb-4 text-center">
                        Mục lục Pháp Điển
                    </Title>
                    <Search
                        placeholder="Tìm kiếm trong mục lục..."
                        prefix={<SearchOutlined className="text-gray-400" />}
                        onChange={onSearchChange}
                        onSearch={onSearch}
                        value={searchText}
                        allowClear
                        className="mb-4"
                    />
                </div>
                <div className="relative">
                    {loading && (
                        <div className="absolute inset-0 z-10 flex items-center justify-center bg-white bg-opacity-75">
                            <Spin size="large" />
                        </div>
                    )}
                    <Tree
                        selectedKeys={selectedKeys}
                        expandedKeys={expandedKeys}
                        onSelect={onSelect}
                        loadData={loadData}
                        treeData={filteredTreeData.map((node) => ({
                            ...node,
                            icon: getIcon(node.icon),
                        }))}
                        showLine
                        className="h-full overflow-auto"
                    />
                </div>
            </Card>
        </motion.div>
    );
}
