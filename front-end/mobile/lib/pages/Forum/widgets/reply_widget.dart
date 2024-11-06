import 'package:flutter/material.dart';

import '../../../models/reply_model.dart';
import '../../../models/user_model.dart';
import '../../../services/comment_service.dart';

class ReplyItemWidget extends StatefulWidget {
  final Reply reply;
  final UserModel currentUser;
  final String postId;
  final String commentId;
  final CommentService commentService;

  const ReplyItemWidget({
    super.key,
    required this.reply,
    required this.currentUser,
    required this.postId,
    required this.commentId,
    required this.commentService,
  });

  @override
  State<ReplyItemWidget> createState() => _ReplyItemWidgetState();
}

class _ReplyItemWidgetState extends State<ReplyItemWidget> {
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await widget.reply.loadUser();
    if (mounted) {
      setState(() => _isLoadingUser = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = widget.reply.user;
    if (user == null) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL!),
                  radius: 16,
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
                        _formatDate(widget.reply.createdAt),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (widget.reply.userId == widget.currentUser.uid)
                  PopupMenuButton(
                    itemBuilder: (context) =>
                    [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Xóa'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        widget.commentService.deleteReply(
                          widget.postId,
                          widget.commentId,
                          widget.reply.id,
                        );
                      }
                    },
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(widget.reply.content),
            ),
            Row(
              children: [
                TextButton.icon(
                  icon: Icon(
                    widget.reply.likes > 0
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  label: Text('${widget.reply.likes}'),
                  onPressed: () {
                    // Implement reply like functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
}