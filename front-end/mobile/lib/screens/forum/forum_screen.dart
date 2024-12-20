import 'package:flutter/material.dart';
import 'package:mobile/screens/forum/widgets/all_posts_tab.dart';
import 'package:mobile/screens/forum/widgets/create_post_dialog.dart';
import 'package:mobile/screens/forum/widgets/user_posts_tab.dart';
import 'package:mobile/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'forum_provider.dart';

class ForumScreenWrapper extends StatelessWidget {
  const ForumScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForumProvider(context),
      child: const ForumScreen(),
    );
  }
}

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ForumProvider>().loadPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForumProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Diễn đàn'),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.lightPrimaryColor,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
              tabs: const [
                Tab(text: 'Tất cả bài viết'),
                Tab(text: 'Bài viết của tôi'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => showCreatePostDialog(context),
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              AllPostsTab(),
              UserPostsTab(),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}