import 'package:flutter/material.dart';
import 'package:mobile/screens/forum/widgets/post_cart.dart';
import 'package:provider/provider.dart';

import '../forum_provider.dart';

class AllPostsTab extends StatelessWidget {
  const AllPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForumProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
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
              ...provider.pinnedPosts.map((post) => PostCard(post: post)),
              const Divider(thickness: 2),
            ],
            ...provider.posts.map((post) => PostCard(post: post)),
          ],
        );
      },
    );
  }
}