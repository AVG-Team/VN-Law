// models/reply_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_response/response_login.dart';

class Reply {
  String id;
  String commentId;
  String content;
  String userId;
  String createdAt;
  int likes;
  UserModel? user;

  Reply({
    required this.id,
    required this.commentId,
    required this.content,
    required this.userId,
    required this.createdAt,
    this.likes = 0,
    this.user,
  });

  factory Reply.fromJson(Map<String, dynamic> json, String id) {
    return Reply(
      id: id,
      commentId: json['commentId'] ?? '',
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      likes: json['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
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
      print("Error loading user data for reply: $e");
    }
  }
}
