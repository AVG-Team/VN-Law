import 'package:VNLAW/screens/forums/providers/post_provider.dart';
import 'package:VNLAW/screens/forums/widget/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/user_info.dart';
import 'create_post_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  ForumScreenState createState() => ForumScreenState();
}

class ForumScreenState extends State<ForumScreen> {
  UserInfo? _userInfo;
  String _filter = 'all'; // 'all', 'pinned', 'liked', 'starred', 'my_posts'
  int _page = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _initializeUserInfo();
  }

  Future<void> _initializeUserInfo() async {
    final userInfo = await UserInfo.initialize();
    setState(() {
      _userInfo = userInfo;
    });
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    if (_userInfo?.accessToken.isNotEmpty ?? false) {
      print("fetch posts");
      await postProvider.fetchPosts(filter: _filter, page: _page, pageSize: _pageSize);
    }
  }

  Future<void> _refreshPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    setState(() {
      _page = 1; // Reset về trang 1 khi làm mới
    });
    await postProvider.fetchPosts(filter: _filter, page: _page, pageSize: _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Pháp Luật'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPosts,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _filter,
              onChanged: (String? newValue) {
                setState(() {
                  _filter = newValue!;
                  _page = 1; // Reset về trang 1 khi thay đổi bộ lọc
                });
                _refreshPosts();
              },
              items: <String>['all', 'pinned', 'liked', 'starred', 'my_posts']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text({
                    'all': 'Tất cả',
                    'pinned': 'Được ghim',
                    'liked': 'Đã thích',
                    'starred': 'Đánh dấu sao',
                    'my_posts': 'Bài của tôi'
                  }[value]!),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading && _page == 1) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                itemCount: postProvider.posts.length + (postProvider.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < postProvider.posts.length) {
                    final post = postProvider.posts[index];
                    return PostCard(post: post);
                  } else if (postProvider.hasMore) {
                    // Tải thêm bài viết khi cuộn tới cuối
                    _page++;
                    postProvider.fetchPosts(filter: _filter, page: _page, pageSize: _pageSize);
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePostScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}