import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../models/comment_model.dart';
import '../models/reply_model.dart';
import '../models/user_model.dart';

class CommentService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Stream<List<Comment>> getCommentsStream(String postId) {
    return _database
        .child('posts')
        .child(postId)
        .child('comments')
        .onValue
        .map((event) {
      final dynamic data = event.snapshot.value;
      print('Raw comments data: $data'); // Debug log

      if (data == null) return [];

      try {
        final List<Comment> comments = [];
        if (data is Map) {
          data.forEach((key, value) {
            if (value is Map) {
              final commentData = Map<String, dynamic>.from(value);
              commentData['id'] = key;
              final comment = Comment.fromJson(commentData, key);
              comments.add(comment);
              print('Loaded comment: ${comment.content}'); // Debug log
            }
          });
        }
        return comments;
      } catch (e) {
        print('Error parsing comments: $e');
        return [];
      }
    });
  }

  Future<void> addComment(String postId, String content, UserModel user) async {
    try {
      final commentRef = _database
          .child('posts')
          .child(postId)
          .child('comments')
          .push();

      await commentRef.set({
        'postId': postId,
        'content': content,
        'userId': user.uid,
        'createdAt': DateTime.now().toIso8601String(),
        'likes': 0,
        'replies': {},
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding comment: $e');
      }
      rethrow;
    }
  }


  Future<String> addReply(
      String postId,
      String commentId,
      String content,
      UserModel user,
      ) async {
    final reply = Reply(
      id: '',
      commentId: commentId,
      content: content,
      userId: user.uid!,
      createdAt: DateTime.now().toIso8601String(),
    );

    final replyRef = _database
        .child('posts/$postId/comments/$commentId/replies')
        .push();
    await replyRef.set(reply.toJson());
    return replyRef.key!;
  }

  // Lấy stream comments
  Stream<List<Comment>> getComments(String postId) {
    return _database.child('posts/$postId/comments').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      return data.entries.map((e) {
        return Comment.fromJson(Map<String, dynamic>.from(e.value), e.key);
      }).toList();
    });
  }

  // Xóa comment
  // Future<void> deleteComment(String postId, String commentId) async {
  //   await _database.child('posts/$postId/comments/$commentId').remove();
  // }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _database
          .child('posts')
          .child(postId)
          .child('comments')
          .child(commentId)
          .remove();
    } catch (e) {
      print('Error deleting comment: $e');
      rethrow;
    }
  }

  Future<void> deleteReply(
      String postId,
      String commentId,
      String replyId,
      ) async {
    await _database
        .child('posts/$postId/comments/$commentId/replies/$replyId')
        .remove();
  }

  // Like/Unlike comment
  Future<void> toggleCommentLike(
      String postId,
      String commentId,
      String userId,
      ) async {
    final likesRef = _database
        .child('posts/$postId/comments/$commentId/likes/$userId');

    final snapshot = await likesRef.get();
    if (snapshot.exists) {
      await likesRef.remove();
    } else {
      await likesRef.set(true);
    }
  }
}
