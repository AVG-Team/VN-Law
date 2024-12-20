import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String content;
  final String authorId;
  final String authorName;
  final String authorPhotoURL;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.authorPhotoURL,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoURL': authorPhotoURL,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      postId: data['postId'],
      content: data['content'],
      authorId: data['authorId'],
      authorName: data['authorName'],
      authorPhotoURL: data['authorPhotoURL'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }
}
