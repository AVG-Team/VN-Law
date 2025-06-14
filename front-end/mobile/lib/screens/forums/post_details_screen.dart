import 'package:VNLAW/screens/forums/providers/post_details_provider.dart';
import 'package:VNLAW/screens/forums/widget/like_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/user_info.dart';

class PostDetailsScreen extends StatefulWidget {
  final String postId;

  const PostDetailsScreen({super.key, required this.postId});

  @override
  PostDetailsScreenState createState() => PostDetailsScreenState();
}

class PostDetailsScreenState extends State<PostDetailsScreen> {
  UserInfo? _userInfo;

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

    if (_userInfo?.accessToken.isNotEmpty ?? false) {
      await context.read<PostDetailsProvider>().fetchPost(widget.postId, _userInfo!.accessToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.error != null) {
          return Scaffold(
            body: Center(child: Text('Lỗi: ${provider.error}')),
          );
        }

        final post = provider.post;
        if (post == null) {
          return const Scaffold(
            body: Center(child: Text('Không tìm thấy bài viết')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Hero(
              tag: 'post_${post.id}_title',
              child: Text(
                post.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.content, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    LikeButton(
                      isLiked: post.isLiked,
                      onTap: () {
                        if (_userInfo?.accessToken != null) {
                          provider.toggleLike(post.id, _userInfo!.accessToken);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.star_border),
                      onPressed: () {
                        // Xử lý star
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => Share.share('${post.title}\n\n${post.content}'),
                    ),
                  ],
                ),
                if (_userInfo?.userRole == 'admin') ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => provider.togglePin(post.id, _userInfo!.accessToken),
                        child: Text(post.isPinned ? 'Bỏ Ghim' : 'Ghim Bài'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await provider.deletePost(post.id, _userInfo!.accessToken);
                          if (provider.post == null) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Xóa Bài'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                const Text(
                  'Bình luận',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Danh sách bình luận ở đây
              ],
            ),
          ),
        );
      },
    );
  }
}