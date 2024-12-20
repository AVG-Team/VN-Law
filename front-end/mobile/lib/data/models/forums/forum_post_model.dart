import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String authorPhotoURL;
  final DateTime createdAt;
  final List<String> likes;
  final bool isPinned;
  final bool isApproved;
  final int commentCount;

  ForumPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.authorPhotoURL,
    required this.createdAt,
    this.likes = const [],
    this.isPinned = false,
    this.isApproved = false,
    this.commentCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoURL': authorPhotoURL,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'isPinned': isPinned,
      'isApproved': isApproved,
      'commentCount': commentCount,
    };
  }

  factory ForumPost.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ForumPost(
      id: doc.id,
      title: data['title'],
      content: data['content'],
      authorId: data['authorId'],
      authorName: data['authorName'],
      authorPhotoURL: data['authorPhotoURL'],
      createdAt: DateTime.parse(data['createdAt']),
      likes: List<String>.from(data['likes'] ?? []),
      isPinned: data['isPinned'] ?? false,
      isApproved: data['isApproved'] ?? false,
      commentCount: data['commentCount'] ?? 0,
    );
  }
}
