import 'package:VNLAW/screens/forums/providers/post_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/forum/post.dart';
import '../../../data/models/user_info.dart';
import 'package:intl/intl.dart';

class PostDetailsScreen extends StatefulWidget {
  final String postId;
  const PostDetailsScreen({required this.postId, super.key});

  @override
  PostDetailsScreenState createState() => PostDetailsScreenState();
}

class PostDetailsScreenState extends State<PostDetailsScreen> {
  UserInfo? userInfo;
  int? replyingToCommentId;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostDetailsProvider>(context, listen: false).fetchPost(widget.postId);
    });
    UserInfo.initialize().then((info) => setState(() => userInfo = info));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.error != null) {
          return Center(child: Text('Lỗi: ${provider.error}'));
        } else if (provider.post == null) {
          return const Center(child: Text('Không tìm thấy bài đăng'));
        }
        final post = provider.post!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chi tiết bài viết'),
            backgroundColor: Colors.blue.shade700,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'star') {
                    await provider.toggleStar(provider.post!.id);
                  } else if (value == 'edit') {
                    _showEditPostDialog(provider, context);
                  } else if (value == 'delete') {
                    _showDeletePostConfirmation(provider, context);
                  } else if (value == 'pin') {
                    await provider.togglePin(provider.post!.id);
                  }
                },
                itemBuilder: (context) {
                  final post = provider.post;
                  if (post == null || userInfo == null) return [];
                  return [
                    PopupMenuItem(
                      value: 'star',
                      child: Text(post.isStarred ? 'Bỏ lưu bài viết' : 'Lưu bài viết'),
                    ),
                    if (post.keycloakId == userInfo!.userId) ...[
                      const PopupMenuItem(value: 'edit', child: Text('Edit post')),
                    ],
                    if (userInfo?.userRole == 'Admin' || post.keycloakId == userInfo!.userId) ...[
                      const PopupMenuItem(value: 'delete', child: Text('Xoá bài viết')),
                    ],
                    if (userInfo?.userRole == 'Admin') ...[
                      PopupMenuItem(
                        value: 'pin',
                        child: Text(post.isPinned ? 'Bỏ ghim bài viết' : 'Ghim bài viết'),
                      ),
                    ],
                  ];
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(post.authorName + (post.isAdmin ? ' • (Quản trị viên)' : '')),
                        subtitle: Text(
                          'Đăng lúc: ${DateFormat('dd/MM/yyyy HH:mm').format(post.createdAt)}\n'
                              'Cập nhật lúc: ${DateFormat('dd/MM/yyyy HH:mm').format(post.updatedAt)}',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.title, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            Text(post.content),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: post.isLiked ? Colors.red : null,
                                ),
                                onPressed: () => provider.toggleLike(post.id),
                              ),
                              Text('${post.likes} lượt thích'),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              Share.share('Xem bài đăng: ${post.title} - https://example.com/${post.id}');
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Bình luận (${post.commentsCount})'),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: post.comments.length,
                        itemBuilder: (context, index) {
                          final comment = post.comments[index];
                          return ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.person)),
                            title: Text(comment.authorName + (comment.isAdmin ? ' • (Quản trị viên)' : '')),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.content),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm').format(comment.createdAt),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: TextButton(
                              onPressed: () => setState(() => replyingToCommentId = comment.id),
                              child: const Text('Trả lời'),
                            ),
                            onTap: () => _showCommentOptions(provider, context, comment),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: replyingToCommentId != null
                              ? 'Trả lời bình luận...'
                              : 'Nhập bình luận',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (_commentController.text.isNotEmpty) {
                          await provider.addComment(
                            post.id,
                            _commentController.text,
                            replyingToCommentId,
                          );
                          _commentController.clear();
                          setState(() => replyingToCommentId = null);
                        }
                      },
                    ),
                    if (replyingToCommentId != null)
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () => setState(() => replyingToCommentId = null),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCommentOptions(PostDetailsProvider provider, BuildContext context, Comment comment) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Trả lời comment'),
              onTap: () {
                setState(() => replyingToCommentId = comment.id);
                Navigator.pop(context);
              },
            ),
            if (comment.keycloakId == userInfo?.userId) ...[
              ListTile(
                title: const Text('Sửa comment'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditCommentDialog(provider, context, comment);
                },
              ),
              ListTile(
                title: const Text('Xoá comment'),
                onTap: () async {
                  Navigator.pop(context);
                  await provider.deleteComment(comment.id);
                },
              ),
            ],
          ],
        );
      },
    );
  }

  void _showEditCommentDialog(PostDetailsProvider provider, BuildContext context, Comment comment) {
    final controller = TextEditingController(text: comment.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa bình luận'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              await provider.updateComment(comment.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showEditPostDialog(PostDetailsProvider provider, BuildContext context) {
    final post = provider.post!;
    final titleController = TextEditingController(text: post.title);
    final contentController = TextEditingController(text: post.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa bài đăng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Tiêu đề')),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Nội dung')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              await provider.updatePost(post.id, titleController.text, contentController.text);
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showDeletePostConfirmation(PostDetailsProvider provider, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa bài đăng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              await provider.deletePost(provider.post!.id);
              Navigator.pop(context);
              Navigator.pop(context); // Quay lại màn hình trước
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}