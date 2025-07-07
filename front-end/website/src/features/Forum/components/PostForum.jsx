import { formatDate } from '../utils/ForumUtil';
import React, { useState, useEffect, useCallback } from 'react';
import { 
  Heart, 
  MessageCircle, 
  Share2, 
  Pin, 
  Edit, 
  Trash2, 
  Send, 
  Reply,
  ChevronDown,
  ChevronUp,
  Star,
  PinOff,
  Search,
  Filter,
  Plus,
  Bell,
  User,
  Settings,
  LogOut,
  MoreVertical,
  Shield
} from 'lucide-react';
import { Button } from './Widget';
import { CommentForm, CommentItem } from './CommentForum';

// Post Actions Component
const PostActions = ({ post, onLike, onStar, onShare, onPin, onEdit, onDelete }) => {
  return (
    <div className="flex items-center justify-between pt-4 border-t">
      <div className="flex items-center gap-6">
        <button
          onClick={() => onLike(post.id)}
          className={`flex items-center gap-2 transition-all duration-200 hover:bg-blue-500 hover:px-[5px] hover:py-[3px] ${
            post.is_liked 
              ? 'text-red-600 scale-105 hover:text-white' 
              : 'text-gray-500 hover:text-white hover:scale-105'
          }`}
        >
          <Heart 
            size={20} 
            fill={post.is_liked ? 'currentColor' : 'none'}
            className="transition-all duration-200"
          />
          <span className="font-medium">{post.likes}</span>
        </button>

        <div className="flex items-center gap-2 text-gray-500">
          <MessageCircle size={20} />
          <span className="font-medium">{post.comments_count}</span>
        </div>

        <button
          onClick={() => onStar(post.id)}
          className={`transition-all duration-200 hover:bg-blue-500 hover:px-[5px] hover:py-[3px] ${
            post.is_starred 
              ? 'text-yellow-500 scale-105' 
              : 'text-gray-500 hover:text-yellow-500 hover:scale-105'
          }`}
        >
          <Star size={20} fill={post.is_starred ? 'currentColor' : 'none'} />
        </button>

        <button
          onClick={() => onShare(post.id)}
          className="text-gray-500 transition-all duration-200 hover:bg-blue-500 hover:px-[5px] hover:py-[3px] hover:text-white hover:scale-105"
        >
          <Share2 size={20} />
        </button>
      </div>

      <div className="flex items-center gap-2">
        {post.is_pinned && (
          <button
            onClick={() => onPin(post.id)}
            className="text-blue-600 transition-colors hover:text-blue-700 hover:bg-white"
          >
            <PinOff size={18} />
          </button>
        )}
        
        {!post.is_pinned && (
          <button
            onClick={() => onPin(post.id)}
            className="text-gray-500 transition-colors hover:text-blue-600 hover:bg-white"
          >
            <Pin size={18} />
          </button>
        )}

        <button
          onClick={() => onEdit(post.id)}
          className="text-gray-500 transition-colors hover:text-blue-600 hover:bg-white"
        >
          <Edit size={18} />
        </button>

        <button
          onClick={() => onDelete(post.id)}
          className="text-gray-500 transition-colors hover:text-red-600 hover:bg-white"
        >
          <Trash2 size={18} />
        </button>
      </div>
    </div>
  );
};

// Post Card Component
const PostCard = ({ post, onClick, onLike, onStar, onShare, onPin, onEdit, onDelete }) => {
  return (
    <div className="overflow-hidden transition-all duration-300 bg-white border border-gray-200 rounded-lg shadow-md hover:shadow-lg">
      <div className="p-6">
        <div className="flex items-start justify-between mb-4">
          <div className="flex items-center gap-3">
            <div className="flex items-center justify-center w-10 h-10 font-semibold text-white bg-blue-600 rounded-full">
              {post.name ? post.name[0] : 'U'}
            </div>
            <div>
              <h3 className="font-semibold text-gray-900">{post.name || 'Unknown User'}</h3>
              <p className="text-sm text-gray-500">{formatDate(post.created_at)}</p>
            </div>
          </div>
          
          {post.is_pinned && (
            <div className="flex items-center gap-1 px-2 py-1 text-sm text-blue-600 rounded-full bg-blue-50">
              <Pin size={14} />
              <span>Ghim</span>
            </div>
          )}
        </div>

        <div className="cursor-pointer" onClick={() => onClick(post)}>
          <h2 className="mb-3 text-xl font-bold text-gray-900 transition-colors hover:text-blue-600">
            {post.title}
          </h2>
          <p className="mb-4 text-gray-700 line-clamp-3">
            {post.content}
          </p>
        </div>

        <PostActions
          post={{
            ...post,
            comments_count: post.commentsCount || 0,
            is_liked: post.is_liked || false,
            is_starred: post.is_starred || false
          }}
          onLike={onLike}
          onStar={onStar}
          onShare={onShare}
          onPin={onPin}
          onEdit={onEdit}
          onDelete={onDelete}
        />
      </div>
    </div>
  );
};

// Post Detail Component
const PostDetail = ({ post, onBack, onLike, onComment, onCommentLike, onCommentReply, onCommentDelete }) => {
  const [comments, setComments] = useState(post.comments || []);

  const handleComment = async (commentData) => {
    const newComment = await onComment(post.id, commentData);
    setComments([newComment, ...comments]);
  };

  const handleCommentReply = async (parentId, replyData) => {
    const newReply = await onCommentReply(post.id, { ...replyData, parent_id: parentId });
    
    setComments(comments.map(comment => {
      if (comment.id === parentId) {
        return {
          ...comment,
          replies: [...(comment.replies || []), newReply]
        };
      }
      return comment;
    }));
  };

  // Tách comments thành parent comments và replies
  const parentComments = comments.filter(comment => !comment.parent_id);
  const replies = comments.filter(comment => comment.parent_id);

  // Gộp replies vào parent comments
  const commentsWithReplies = parentComments.map(comment => ({
    ...comment,
    replies: replies.filter(reply => reply.parent_id === comment.id)
  }));

  return (
    <div className="max-w-4xl mx-auto">
      <button
        onClick={onBack}
        className="mb-6 font-medium text-blue-600 hover:text-blue-700"
      >
        ← Quay lại danh sách
      </button>

      <div className="p-8 mb-6 bg-white rounded-lg shadow-md">
        <div className="flex items-center gap-3 mb-6">
          <div className="flex items-center justify-center w-12 h-12 text-lg font-semibold text-white bg-blue-600 rounded-full">
            {post.name ? post.name[0] : 'U'}
          </div>
          <div>
            <h3 className="text-lg font-semibold text-gray-900">{post.name || 'Unknown User'}</h3>
            <p className="text-gray-500">{formatDate(post.created_at)}</p>
          </div>
        </div>

        <h1 className="mb-6 text-3xl font-bold text-gray-900">{post.title}</h1>
        <div className="mb-8 prose max-w-none">
          <p className="text-lg leading-relaxed text-gray-700 whitespace-pre-wrap">
            {post.content}
          </p>
        </div>

        <PostActions
          post={{
            ...post,
            comments_count: post.commentsCount || 0,
            is_liked: post.is_liked || false,
            is_starred: post.is_starred || false
          }}
          onLike={onLike}
          onStar={() => {}}
          onShare={() => {}}
          onPin={() => {}}
          onEdit={() => {}}
          onDelete={() => {}}
        />
      </div>

      <div className="p-6 bg-white rounded-lg shadow-md">
        <h3 className="mb-6 text-xl font-semibold">
          Bình luận ({comments.length})
        </h3>

        <div className="mb-6">
          <CommentForm onSubmit={handleComment} />
        </div>

        <div className="space-y-4">
          {commentsWithReplies
            .sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
            .map(comment => (
              <CommentItem
                key={comment.id}
                comment={{
                  ...comment,
                  authorName: comment.name,
                  createdAt: comment.created_at,
                  keycloakId: comment.keycloak_id,
                  isAdmin: comment.is_admin
                }}
                onLike={onCommentLike}
                onReply={handleCommentReply}
                onDelete={onCommentDelete}
              />
            ))}
        </div>
      </div>
    </div>
  );
};

// Create Post Form Component
const CreatePostForm = ({ onSubmit, onCancel }) => {
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!title.trim() || !content.trim()) return;

    setIsSubmitting(true);
    try {
      await onSubmit({ title: title.trim(), content: content.trim() });
      setTitle("");
      setContent("");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label className="block mb-2 text-sm font-medium text-gray-700">
          Tiêu đề
        </label>
        <input
          type="text"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          placeholder="Nhập tiêu đề bài viết..."
          required
        />
      </div>
      <div>
        <label className="block mb-2 text-sm font-medium text-gray-700">
          Nội dung
        </label>
        <textarea
          value={content}
          onChange={(e) => setContent(e.target.value)}
          rows={6}
          className="w-full px-3 py-2 border border-gray-300 rounded-lg resize-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          placeholder="Chia sẻ suy nghĩ của bạn..."
          required
        />
      </div>
      <div className="flex justify-end gap-3">
        <Button variant="secondary" onClick={onCancel} disabled={isSubmitting}>
          Hủy
        </Button>
        <Button type="submit" disabled={isSubmitting || !title.trim() || !content.trim()}>
          {isSubmitting ? "Đang đăng..." : "Đăng bài"}
        </Button>
      </div>
    </form>
  );
};

export {PostActions, PostCard, PostDetail, CreatePostForm};