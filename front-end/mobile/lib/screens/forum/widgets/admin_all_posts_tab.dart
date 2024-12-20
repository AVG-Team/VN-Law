import 'package:flutter/material.dart';
import 'package:mobile/screens/forum/widgets/post_cart.dart';
import 'package:provider/provider.dart';

import '../forum_provider.dart';
import 'admin_post_cart.dart';

class AdminAllPostsTab extends StatelessWidget {
  const AdminAllPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForumProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            // Pinned Posts Section
            if (provider.pinnedPosts.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Bài viết ghim',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...provider.pinnedPosts.map((post) => PostCard(
                post: post,
                isAdmin: true,
              )),
              const Divider(thickness: 2),
            ],

            // Regular Posts
            ...provider.posts.map((post) => PostCard(
              post: post,
              isAdmin: true,
            )),
          ],
        );
      },
    );
  }
}

// screens/admin/pending_posts_tab.dart
class PendingPostsTab extends StatelessWidget {
  const PendingPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForumProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.pendingPosts.isEmpty) {
          return const Center(
            child: Text('Không có bài viết nào đang chờ duyệt'),
          );
        }

        return ListView.builder(
          itemCount: provider.pendingPosts.length,
          itemBuilder: (context, index) {
            final post = provider.pendingPosts[index];
            return AdminPostCard(
              post: post,
              onApprove: () => provider.approvePost(post.id),
              onReject: () => provider.deletePost(post.id),
            );
          },
        );
      },
    );
  }
}
