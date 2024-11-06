// screens/post_screen.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/Forum/widgets/comment_widget.dart';
import 'package:provider/provider.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_provider.dart';
import '../../services/comment_service.dart';

class PostScreen extends StatefulWidget {
  final Question question;
  const PostScreen({
    super.key,
    required this.question,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final AuthProviderCustom _authProvider;
  late final CommentService _commentService;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProviderCustom>(context, listen: false);
    _commentService = CommentService();
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const SizedBox(width: 5.0),
                  const Text(
                    "Chi tiết bài viết",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),

            // Post Content
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26.withOpacity(0.05),
                        offset: const Offset(0.0, 6.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.10
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // User info
                    FutureBuilder<UserModel?>(
                      future: widget.question.getUserModelIdFromUserId(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final user = snapshot.data;
                        if (user == null) return const SizedBox();

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user.photoURL ?? ''),
                                  radius: 22,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.displayName ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formatDate(widget.question.createdAt),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Actions menu
                            if (_authProvider.userModel?.uid == widget.question.idUser ||
                                _authProvider.userModel!.isAdmin)
                              PopupMenuButton<String>(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Xóa'),
                                      ],
                                    ),
                                  ),
                                  if (_authProvider.userModel!.isAdmin)
                                    const PopupMenuItem(
                                      value: 'pin',
                                      child: Row(
                                        children: [
                                          Icon(Icons.push_pin, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text('Ghim'),
                                        ],
                                      ),
                                    ),
                                ],
                                onSelected: (value) {
                                  // Implement actions
                                },
                              ),
                          ],
                        );
                      },
                    ),

                    // Post title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        widget.question.question,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Post content
                    Text(
                      widget.question.content,
                      style: const TextStyle(fontSize: 16),
                    ),

                    // Post stats
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        children: [
                          Icon(Icons.favorite,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () async {
                          final String userId = _authProvider.userModel?.uid ?? 'defaultUid';
                          final String nodeKey = widget.question.nodeKey;
                          final DatabaseReference ref = FirebaseDatabase.instance.ref("posts/$nodeKey");
                          try {
                            final snapshot = await ref.get();
                            if (!snapshot.exists) {
                              throw Exception("Post not found");
                            }
                            final data = Map<String, dynamic>.from(snapshot.value as Map);
                            List<String> votedUserIds = List<String>.from(data['votedUserIds'] ?? []);
                            int votes = data['votes'] ?? 0;
                            // Kiểm tra xem người dùng đã vote chưa
                            bool hasVoted = votedUserIds.contains(userId);
                            // Nếu đã vote thì unvote, chưa vote thì vote
                            if (hasVoted) {
                              // Unvote - chỉ khi người dùng đã vote trước đó
                              votedUserIds.remove(userId);
                              votes = votes - 1;
                            } else {
                              // Vote - chỉ khi người dùng chưa vote
                              if (!votedUserIds.contains(userId)) {  // Thêm kiểm tra để tránh vote trùng
                                votedUserIds.add(userId);
                                votes = votes + 1;
                              }
                            }
                            await ref.update({
                              'votes': votes,
                              'votedUserIds': votedUserIds,
                            });
                          } catch (error) {
                            print("Failed to toggle vote: $error");
                          }
                        },
                        child: StreamBuilder(
                          stream: FirebaseDatabase.instance
                              .ref("posts/${widget.question.nodeKey}")
                              .onValue,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
                              final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              final votedUserIds = List<String>.from(data['votedUserIds'] ?? []);
                              final userId = _authProvider.userModel?.uid ?? 'defaultUid';
                              final isVoted = votedUserIds.contains(userId);
                              final votes = data['votes'] ?? 0;
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.thumb_up,
                                    color: isVoted ? Colors.blue : Colors.grey.withOpacity(0.6),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    "$votes likes",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            }
                            // Khi đang load dữ liệu, hiển thị UI mặc định
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Icon(
                                  Icons.thumb_up,
                                  color: Colors.grey.withOpacity(0.6),
                                  size: 22,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  "0 likes",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.withOpacity(0.6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                          const SizedBox(width: 16),
                          Icon(Icons.comment,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Bình luận',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Comments section
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CommentWidget(
                postId: widget.question.nodeKey,
                currentUser: _authProvider.userModel!,
                commentService: _commentService,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
