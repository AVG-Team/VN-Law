import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/forums/forum_post_model.dart';

class AdminPostCard extends StatelessWidget {
  final ForumPost post;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const AdminPostCard({
    super.key,
    required this.post,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
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
          OverflowBar(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text('Từ chối'),
                onPressed: onReject,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Duyệt'),
                onPressed: onApprove,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
