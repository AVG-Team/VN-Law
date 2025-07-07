import React, { useState, useEffect } from "react";
import { Modal, Button, LoadingSpinner } from "./components/Widget";
import forumApi from "./ApiService";
import { PostActions, PostCard, PostDetail, CreatePostForm } from "./components/PostForum";

// Main App Component
const ForumApp = () => {
    const [posts, setPosts] = useState([]);
    const [selectedPost, setSelectedPost] = useState(null);
    const [showCreateForm, setShowCreateForm] = useState(false);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadPosts();
    }, []);

    const loadPosts = async () => {
        try {
            setLoading(true);
            const response = await forumApi.getPosts();
            setPosts(response.data.posts);
        } catch (error) {
            console.error("Error loading posts:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleCreatePost = async (postData) => {
        try {
            const response = await forumApi.createPost(postData);
            setPosts([response.data.post, ...posts]);
            setShowCreateForm(false);
        } catch (error) {
            console.error("Error creating post:", error);
        }
    };

    const handleLikePost = async (postId) => {
        try {
            await forumApi.likePost(postId);
            setPosts(
                posts.map((post) =>
                    post.id === postId
                        ? {
                              ...post,
                              is_liked: !post.is_liked,
                              likes: post.is_liked ? post.likes - 1 : post.likes + 1,
                          }
                        : post,
                ),
            );
        } catch (error) {
            console.error("Error liking post:", error);
        }
    };

    const handleComment = async (postId, commentData) => {
        try {
            const response = await forumApi.createComment(postId, commentData);
            return response.data.comment;
        } catch (error) {
            console.error("Error creating comment:", error);
        }
    };

    const handleCommentLike = async (commentId) => {
        console.log("Like comment:", commentId);
    };

    const handleCommentReply = async (postId, replyData) => {
        try {
            const response = await forumApi.createComment(postId, replyData);
            return response.data.comment;
        } catch (error) {
            console.error("Error creating reply:", error);
        }
    };

    const handleCommentDelete = async (commentId) => {
        try {
            await forumApi.deleteComment(commentId);
            // Refresh posts to update comments
            loadPosts();
        } catch (error) {
            console.error("Error deleting comment:", error);
        }
    };

    if (loading) {
        return (
            <div className="min-h-screen bg-gray-50">
                <LoadingSpinner />
            </div>
        );
    }

    if (selectedPost) {
        return (
            <div className="min-h-screen p-6 bg-gray-50">
                <PostDetail
                    post={selectedPost}
                    onBack={() => setSelectedPost(null)}
                    onLike={handleLikePost}
                    onComment={handleComment}
                    onCommentLike={handleCommentLike}
                    onCommentReply={handleCommentReply}
                    onCommentDelete={handleCommentDelete}
                />
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50">
            {/* Header */}
            <header className="bg-white border-b shadow-sm">
                <div className="max-w-6xl px-6 py-4 mx-auto">
                    <div className="flex items-center justify-between">
                        <h1 className="text-2xl font-bold text-blue-600">Diễn đàn Pháp luật Việt Nam</h1>
                        <Button onClick={() => setShowCreateForm(true)}>Tạo bài viết mới</Button>
                    </div>
                </div>
            </header>

            {/* Main Content */}
            <main className="max-w-6xl px-6 py-8 mx-auto">
                <div className="grid gap-6">
                    {posts
                        .sort((a, b) => {
                            if (a.is_pinned && !b.is_pinned) return -1;
                            if (!a.is_pinned && b.is_pinned) return 1;
                            return new Date(b.created_at) - new Date(a.created_at);
                        })
                        .map((post) => (
                            <PostCard
                                key={post.id}
                                post={post}
                                onClick={setSelectedPost}
                                onLike={handleLikePost}
                                onStar={() => forumApi.starPost(post.id)}
                                onShare={() => console.log("Share post:", post.id)}
                                onPin={() => forumApi.pinPost(post.id)}
                                onEdit={() => console.log("Edit post:", post.id)}
                                onDelete={() => forumApi.deletePost(post.id)}
                            />
                        ))}
                </div>
            </main>

            {/* Create Post Modal */}
            <Modal isOpen={showCreateForm} onClose={() => setShowCreateForm(false)} title="Tạo bài viết mới">
                <CreatePostForm onSubmit={handleCreatePost} onCancel={() => setShowCreateForm(false)} />
            </Modal>
        </div>
    );
};

export default ForumApp;
