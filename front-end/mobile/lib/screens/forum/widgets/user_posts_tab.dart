import 'package:flutter/material.dart';
import 'package:mobile/screens/forum/widgets/post_cart.dart';
import 'package:provider/provider.dart';

import '../forum_provider.dart';

class UserPostsTab extends StatelessWidget {
  const UserPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForumProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.userPosts.isEmpty) {
          return const Center(
            child: Text('Bạn chưa có bài viết nào'),
          );
        }

        return ListView.builder(
          itemCount: provider.userPosts.length,
          itemBuilder: (context, index) {
            return PostCard(
              post: provider.userPosts[index],
              showStatus: true,
            );
          },
        );
      },
    );
  }
}
