import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/forum/post.dart';
import '../post_details_screen.dart';
import '../providers/post_provider.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  String _truncateContent(String content) {
    if (content.length <= 200) {
      return content;
    }
    return '${content.substring(0, 200)}...';
  }

  // void _showSharePopup(BuildContext context) {
  //   final link = 'https://example.com/post/${post.id}';
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Chia sẻ liên kết'),
  //       content: Text('Liên kết: $link'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Clipboard.setData(ClipboardData(text: link));
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text('Đã sao chép liên kết!')),
  //             );
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Copy link'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Đóng'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _navigateToDetails(BuildContext context) {
    print("Navigating to post details for post ID: ${post.id}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailsScreen(postId: post.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToDetails(context), // Nhấn bất kỳ đâu trên card để xem chi tiết
        borderRadius: BorderRadius.circular(12), // Bo góc để khớp với Card
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _truncateContent(post.content),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Tác giả: ${post.authorName}'
                    '${post.isAdmin ? ' • (Quản trị viên)' : ''}'
                    ' • ${post.createdAt.toLocal().toString().split('.')[0]}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 16,
                        color: post.isLiked ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text('${post.likes} Thích'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.comment, size: 16),
                      const SizedBox(width: 4),
                      Text('${post.comments.length} Bình luận'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Consumer<PostProvider>(
                builder: (context, provider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () => _navigateToDetails(context), // Nút Bình luận cũng chuyển hướng
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.comment, size: 16),
                            SizedBox(width: 6),
                            Text('Bình luận'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          Share.share('Xem bài đăng: ${post.title} - https://example.com/${post.id}');
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.share, size: 16),
                            SizedBox(width: 6),
                            Text('Chia sẻ'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}