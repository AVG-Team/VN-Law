import 'package:flutter/material.dart';
import 'package:mobile/pages/Forum/widgets/reply_widget.dart';

import '../../../models/comment_model.dart';
import '../../../models/user_model.dart';
import '../../../services/comment_service.dart';

class CommentItemWidget extends StatefulWidget {
  final Comment comment;
  final UserModel currentUser;
  final String postId;
  final CommentService commentService;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.currentUser,
    required this.postId,
    required this.commentService,
  });

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  final TextEditingController _replyController = TextEditingController();
  bool _isReplying = false;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await widget.comment.loadUser();
    if (mounted) {
      setState(() => _isLoadingUser = false);
    }
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return const Card(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final user = widget.comment.user;
    if (user == null) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL!),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatDate(widget.comment.createdAt),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (widget.comment.userId == widget.currentUser.uid)
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Xóa'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        widget.commentService.deleteComment(
                          widget.postId,
                          widget.comment.id,
                        );
                      }
                    },
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(widget.comment.content),
            ),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.reply),
                  label: const Text('Trả lời'),
                  onPressed: () {
                    setState(() => _isReplying = !_isReplying);
                  },
                ),
                TextButton.icon(
                  icon: Icon(
                    widget.comment.likes > 0
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  label: Text('${widget.comment.likes}'),
                  onPressed: () {
                    widget.commentService.toggleCommentLike(
                      widget.postId,
                      widget.comment.id,
                      widget.currentUser.uid!,
                    );
                  },
                ),
              ],
            ),
            if (_isReplying)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyController,
                        decoration: const InputDecoration(
                          hintText: 'Viết trả lời...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (_replyController.text.trim().isEmpty) return;

                        await widget.commentService.addReply(
                          widget.postId,
                          widget.comment.id,
                          _replyController.text.trim(),
                          widget.currentUser,
                        );

                        _replyController.clear();
                        setState(() => _isReplying = false);
                      },
                    ),
                  ],
                ),
              ),

            if (widget.comment.replies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Column(
                  children: widget.comment.replies.map((reply) {
                    return ReplyItemWidget(
                      reply: reply,
                      currentUser: widget.currentUser,
                      postId: widget.postId,
                      commentId: widget.comment.id,
                      commentService: widget.commentService,
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
