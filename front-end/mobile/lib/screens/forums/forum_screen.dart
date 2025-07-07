import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:VNLAW/screens/forums/providers/post_provider.dart';
import 'package:VNLAW/screens/forums/widget/post_card.dart';
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
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeUserInfo();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !Provider.of<PostProvider>(context, listen: false).isFetchingPosts &&
          Provider.of<PostProvider>(context, listen: false).hasMore) {
        _page++;
        Provider.of<PostProvider>(context, listen: false)
            .fetchPosts(filter: _filter, page: _page, pageSize: _pageSize);
      }
    });
  }

  Future<void> _initializeUserInfo() async {
    final userInfo = await UserInfo.initialize();
    setState(() {
      _userInfo = userInfo;
    });
    if (_userInfo?.accessToken.isNotEmpty ?? false) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      print("fetch posts");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        postProvider.fetchPosts(filter: _filter, page: _page, pageSize: _pageSize);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    setState(() {
      _page = 1;
    });
    await postProvider.fetchPosts(filter: _filter, page: _page, pageSize: _pageSize);
  }

  void _onFilterSelected(String newFilter) {
    setState(() {
      _filter = newFilter;
      _page = 1;
    });
    _refreshPosts();
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Forum Pháp Luật'),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPosts,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bộ lọc bài viết',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildFilterTile('all', 'Tất cả'),
                  _buildFilterTile('pinned', 'Được ghim'),
                  _buildFilterTile('liked', 'Đã thích'),
                  _buildFilterTile('starred', 'Bài đã lưu'),
                  _buildFilterTile('my_posts', 'Bài của tôi'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isFetchingPosts && _page == 1) {
            return Center(
              child: const CircularProgressIndicator()
                  .animate()
                  .scale(duration: 300.ms, curve: Curves.easeInOut),
            );
          }
          return RefreshIndicator(
            onRefresh: _refreshPosts,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: postProvider.posts.length + (postProvider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < postProvider.posts.length) {
                  final post = postProvider.posts[index];
                  return PostCard(post: post)
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: (100 * index).ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.2,
                        end: 0.0,
                        duration: 400.ms,
                        delay: (100 * index).ms,
                        curve: Curves.easeOut,
                      );
                } else {
                  return Center(
                    child: const CircularProgressIndicator()
                        .animate()
                        .scale(duration: 300.ms, curve: Curves.easeInOut),
                  );
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreatePostScreen()),
        ),
        child: const Icon(Icons.add),
      ).animate().scale(duration: 300.ms, curve: Curves.easeInOut),
    );
  }

  Widget _buildFilterTile(String value, String label) {
    final isSelected = _filter == value;
    return ListTile(
      leading: Icon(
        {
          'all': Icons.list,
          'pinned': Icons.push_pin,
          'liked': Icons.favorite,
          'starred': Icons.star,
          'my_posts': Icons.person,
        }[value],
        color: isSelected ? Colors.blue.shade700 : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blue.shade700 : Colors.black87,
        ),
      ),
      onTap: () => _onFilterSelected(value),
      tileColor: isSelected ? Colors.grey[200] : null,
    ).animate().fadeIn(duration: 300.ms, curve: Curves.easeInOut);
  }
}