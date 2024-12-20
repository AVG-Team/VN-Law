import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../data/models/forums/forum_post_model.dart';
import '../../../services/auth_provider.dart';
import '../comments_screen.dart';
import '../forum_provider.dart';

class PostCard extends StatelessWidget {
  final ForumPost post;
  final bool showStatus;
  final bool isAdmin;

  const PostCard({
    super.key,
    required this.post,
    this.showStatus = false,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProviderCustom>().userModel;
    final provider = context.read<ForumProvider>();

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.authorPhotoURL),
            ),
            title: Text(post.authorName),
            subtitle: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(post.createdAt),
            ),
            trailing: post.isPinned ? const Icon(Icons.push_pin) : null,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(post.content),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                icon: Icon(
                  post.likes.contains(user?.uid)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                label: Text('${post.likes.length}'),
                onPressed: user != null
                    ? () => provider.toggleLike(post.id)
                    : null,
              ),
              TextButton.icon(
                icon: const Icon(Icons.comment),
                label: Text('${post.commentCount}'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommentsScreen(post: post),
                  ),
                ),
              ),
              if (isAdmin || post.authorId == user?.uid)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    if (isAdmin) ...[
                      PopupMenuItem(
                        child: Text(post.isPinned ? 'Bỏ ghim' : 'Ghim bài viết'),
                        onTap: () => provider.togglePin(post.id, !post.isPinned),
                      ),
                    ],
                    PopupMenuItem(
                      child: const Text('Xóa bài viết'),
                      onTap: () => provider.deletePost(post.id),
                    ),
                  ],
                ),
            ],
          ),
          if (showStatus && !post.isApproved)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Đang chờ duyệt',
                style: TextStyle(
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}