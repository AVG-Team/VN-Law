import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../forum_provider.dart';

// widgets/create_post_dialog.dart
void showCreatePostDialog(BuildContext context) {
  final forumProvider = context.read<ForumProvider>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Tạo bài viết mới'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Tiêu đề',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: 'Nội dung',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
              forumProvider.createPost(
                titleController.text,
                contentController.text,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Đăng', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}