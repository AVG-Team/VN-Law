import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import './user_model.dart';
import './reply_model.dart';

class Comment {
  String id;
  String postId;
  String content;
  String userId;
  String createdAt;
  List<Reply> replies;
  int likes;
  UserModel? user;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.userId,
    required this.createdAt,
    this.replies = const [],
    this.likes = 0,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json, String id) {
    List<Reply> repliesList = [];

    try {
      if (json['replies'] != null && json['replies'] is Map) {
        final repliesMap = json['replies'] as Map<dynamic, dynamic>;
        repliesList = repliesMap.entries.map((e) {
          final replyData = Map<String, dynamic>.from(e.value);
          print('Processing reply: $replyData'); // Debug log
          return Reply.fromJson(replyData, e.key.toString());
        }).toList();

        // Sort replies by creation date
        repliesList.sort((a, b) =>
            DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
      }
    } catch (e) {
      print('Error parsing replies: $e');
    }

    return Comment(
      id: id,
      postId: json['postId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      likes: json['likes'] as int? ?? 0,
      replies: repliesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'content': content,
      'userId': userId,
      'createdAt': createdAt,
      'likes': likes,
    };
  }

  Future<void> loadUser() async {
    if (user != null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // user = UserModel.fromFirestore(userDoc);
      }
    } catch (e) {
      print("Error loading user data for comment: $e");
    }
  }
}
