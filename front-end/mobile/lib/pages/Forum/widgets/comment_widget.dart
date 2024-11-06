import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/comment_model.dart';
import '../../../models/user_model.dart';
import '../../../services/comment_service.dart';
import 'comment_item_widget.dart';

class CommentWidget extends StatefulWidget {
  final String postId;
  final UserModel currentUser;
  final CommentService commentService;

  const CommentWidget({
    super.key,
    required this.postId,
    required this.currentUser,
    required this.commentService,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.commentService.addComment(
        widget.postId,
        _commentController.text.trim(),
        widget.currentUser,
      );
      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Comment input
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Viết bình luận...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send),
                onPressed: _isSubmitting ? null : _addComment,
              ),
            ],
          ),
        ),

        // Comments list
        StreamBuilder<List<Comment>>(
          stream: widget.commentService.getCommentsStream(widget.postId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final comments = snapshot.data!;
            if (comments.isEmpty) {
              return const Center(child: Text('Chưa có bình luận nào'));
            }

            print('Loaded ${comments.length} comments');
            comments.sort((a, b) =>
                DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return CommentItemWidget(
                  key: ValueKey(comment.id),
                  comment: comment,
                  currentUser: widget.currentUser,
                  postId: widget.postId,
                  commentService: widget.commentService,
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

