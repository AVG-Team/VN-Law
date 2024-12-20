import 'package:flutter/material.dart';
import 'package:mobile/screens/forum/widgets/admin_all_posts_tab.dart';
import 'package:mobile/screens/forum/widgets/admin_post_cart.dart';
import 'package:provider/provider.dart';

import 'forum_provider.dart';

// screens/admin/admin_panel_screen.dart
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Provider.of<ForumProvider>(context, listen: false).loadPendingPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý diễn đàn'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chờ duyệt'),
            Tab(text: 'Tất cả bài viết'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PendingPostsTab(),
          AdminAllPostsTab(),
        ],
      ),
    );
  }
}

class PendingPostsTab extends StatelessWidget {
  const PendingPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForumProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
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