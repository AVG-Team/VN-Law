import { formatDate } from '../utils/ForumUtil';
import React, { useState, useEffect, useCallback } from 'react';
import { 
  Edit, 
  Trash2, 
  Send, 
  Reply,
  ChevronDown,
  ChevronUp,
  MoreVertical,
  Shield
} from 'lucide-react';
import { Button } from './Widget';

// Comment Form
const CommentForm = ({ 
  onSubmit, 
  placeholder = "Viết bình luận...", 
  parentId = null,
  autoFocus = false 
}) => {
  const [content, setContent] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!content.trim()) return;

    setIsSubmitting(true);
    try {
      await onSubmit({ content: content.trim(), parent_id: parentId });
      setContent("");
    } catch (error) {
      console.error('Error creating comment:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="flex gap-3">
      <div className="flex-1">
        <input
          type="text"
          value={content}
          onChange={(e) => setContent(e.target.value)}
          className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          placeholder={placeholder}
          autoFocus={autoFocus}
          maxLength={500}
        />
      </div>
      <Button 
        type="submit" 
        size="sm" 
        loading={isSubmitting}
        disabled={!content.trim()}
      >
        <Send size={16} />
      </Button>
    </form>
  );
};

// Comment Item
const CommentItem = ({ 
  comment, 
  onReply, 
  onEdit, 
  onDelete, 
  level = 0,
  currentUserId = null 
}) => {
  const [showReplyForm, setShowReplyForm] = useState(false);
  const [showReplies, setShowReplies] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [editContent, setEditContent] = useState(comment.content);

  const isOwner = currentUserId === comment.keycloakId;
  const maxLevel = 2;

  const handleReply = async (replyData) => {
    await onReply(comment.id, replyData);
    setShowReplyForm(false);
  };

  const handleEdit = async () => {
    if (!editContent.trim()) return;
    
    try {
      await onEdit(comment.id, { content: editContent.trim() });
      setIsEditing(false);
    } catch (error) {
      console.error('Error editing comment:', error);
    }
  };

  return (
    <div className={`${level > 0 ? 'ml-8 border-l-2 border-gray-200 pl-4' : ''}`}>
      <div className="p-4 mb-3 transition-colors rounded-lg bg-gray-50 hover:bg-gray-100">
        <div className="flex items-start justify-between mb-2">
          <div className="flex items-center gap-3">
            <div className="flex items-center justify-center w-8 h-8 text-sm font-semibold text-white bg-blue-600 rounded-full">
              {comment.name ? comment.name[0].toUpperCase() : 'U'}
            </div>
            <div className="flex items-center gap-2">
              <span className="font-medium text-gray-900">
                {comment.name || 'Người dùng'}
              </span>
              {comment.isAdmin && (
                <Shield size={14} className="text-blue-600" title="Quản trị viên" />
              )}
              <span className="text-sm text-gray-500">
                {formatDate(comment.createdAt)}
              </span>
            </div>
          </div>
          
          {isOwner && (
            <DropdownMenu
              trigger={
                <button className="p-1 text-gray-400 rounded hover:text-gray-600">
                  <MoreVertical size={16} />
                </button>
              }
            >
              <button
                onClick={() => setIsEditing(true)}
                className="flex items-center w-full gap-2 px-4 py-2 text-left hover:bg-gray-100"
              >
                <Edit size={14} />
                Chỉnh sửa
              </button>
              <button
                onClick={() => onDelete(comment.id)}
                className="flex items-center w-full gap-2 px-4 py-2 text-left text-red-600 hover:bg-gray-100"
              >
                <Trash2 size={14} />
                Xóa
              </button>
            </DropdownMenu>
          )}
        </div>
        
        {isEditing ? (
          <div className="mb-3">
            <textarea
              value={editContent}
              onChange={(e) => setEditContent(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg resize-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              rows={3}
            />
            <div className="flex gap-2 mt-2">
              <Button size="sm" onClick={handleEdit}>
                Lưu
              </Button>
              <Button 
                size="sm" 
                variant="secondary" 
                onClick={() => {
                  setIsEditing(false);
                  setEditContent(comment.content);
                }}
              >
                Hủy
              </Button>
            </div>
          </div>
        ) : (
          <p className="mb-3 text-gray-700 whitespace-pre-wrap">{comment.content}</p>
        )}
        
        <div className="flex items-center gap-4">
          {level < maxLevel && (
            <button
              onClick={() => setShowReplyForm(!showReplyForm)}
              className="flex items-center gap-1 text-sm text-gray-500 transition-colors hover:text-blue-600"
            >
              <Reply size={16} />
              Trả lời
            </button>
          )}
        </div>
      </div>

      {showReplyForm && (
        <div className="mb-4">
          <CommentForm 
            onSubmit={handleReply}
            placeholder={`Trả lời ${comment.name || 'bình luận'}...`}
            parentId={comment.id}
            autoFocus={true}
          />
        </div>
      )}

      {comment.replies && comment.replies.length > 0 && (
        <div>
          <button
            onClick={() => setShowReplies(!showReplies)}
            className="flex items-center gap-1 mb-3 text-sm text-blue-600 transition-colors hover:text-blue-700"
          >
            {showReplies ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
            {showReplies ? 'Ẩn' : 'Hiện'} {comment.replies.length} phản hồi
          </button>
          
          {showReplies && (
            <div className="space-y-3">
              {comment.replies
                .sort((a, b) => new Date(a.createdAt) - new Date(b.createdAt))
                .map(reply => (
                  <CommentItem
                    key={reply.id}
                    comment={reply}
                    onReply={onReply}
                    onEdit={onEdit}
                    onDelete={onDelete}
                    level={level + 1}
                    currentUserId={currentUserId}
                  />
                ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export { CommentForm, CommentItem };