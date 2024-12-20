import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../data/models/forums/comment_model.dart';
import '../../../services/auth_provider.dart';
import '../forum_provider.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProviderCustom>().userModel;
    final provider = context.read<ForumProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(comment.authorPhotoURL),
        ),
        title: Row(
          children: [
            Text(comment.authorName),
            const SizedBox(width: 8),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(comment.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        subtitle: Text(comment.content),
        trailing: (user?.isAdmin == true || comment.authorId == user?.uid)
            ? IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => provider.deleteComment(
            comment.postId,
            comment.id,
          ),
        )
            : null,
      ),
    );
  }
}