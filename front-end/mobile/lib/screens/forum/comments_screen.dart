import 'package:flutter/material.dart';
import 'package:mobile/screens/forum/widgets/comment_card.dart';
import 'package:mobile/screens/forum/widgets/post_cart.dart';
import 'package:provider/provider.dart';

import '../../data/models/forums/forum_post_model.dart';
import '../../services/auth_provider.dart';
import 'forum_provider.dart';

class CommentsScreenWrapper extends StatelessWidget {
  final ForumPost post;
  const CommentsScreenWrapper({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForumProvider(context),
      child: CommentsScreen(post: post),
    );
  }
}

class CommentsScreen extends StatefulWidget {
  final ForumPost post;
  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ForumProvider>(context, listen: false)
        .loadComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bình luận'),
      ),
      body: Column(
        children: [
          PostCard(post: widget.post),
          Expanded(
            child: Consumer<ForumProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.comments.length,
                  itemBuilder: (context, index) {
                    return CommentCard(
                      comment: provider.comments[index],
                    );
                  },
                );
              },
            ),
          ),
          if (context.read<AuthProviderCustom>().userModel != null)
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
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        context.read<ForumProvider>().addComment(
                          widget.post.id,
                          _commentController.text,
                        );
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}