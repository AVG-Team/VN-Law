import 'package:VNLAW/screens/forums/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/forum/post.dart';
import '../services/post_service.dart';
import '../../../data/models/user_info.dart';

class PostDetailsProvider with ChangeNotifier {
  Post? _post;
  bool _isLoading = false;
  String? _error;
  List<String> _likedPosts = [];
  List<String> _starredPosts = [];

  Post? get post => _post;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get likedPosts => _likedPosts;
  List<String> get starredPosts => _starredPosts;

  Future<void> fetchPost(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _likedPosts = await PostService.getLikedPostIds();
      _starredPosts = await PostService.getStarredPostIds();
      _post = await PostService.getPost(id);
      _post!.isLiked = _likedPosts.contains(_post!.id);
    } catch (e) {
      _error = e.toString();
      print('Error fetching post: $e');
      _post = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String postId, BuildContext context) async {
    try {
      await PostService.likePost(postId);
      if (_post != null) {
        _post!.isLiked = !_post!.isLiked;
        _post!.likes = _post!.likes + (_post!.isLiked ? 1 : -1);
        print('Post ${_post!.id} like status: ${_post!.isLiked}');
        print('Post ${_post!.id} likes count: ${_post!.likes}');
        notifyListeners();

        // Cập nhật PostProvider
        final postProvider = Provider.of<PostProvider>(context, listen: false);
        postProvider.updatePost(_post!);
      }
    } catch (e) {
      _error = e.toString();
      print('Error toggling like: $e');
      notifyListeners();
    }
  }

  Future<void> togglePin(String postId) async {
    try {
      if (_post != null) {
        if (_post!.isPinned) {
          await PostService.unpinPost(postId);
          _post!.isPinned = false;
        } else {
          await PostService.pinPost(postId);
          _post!.isPinned = true;
        }
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      print('Error toggling pin: $e');
      notifyListeners();
    }
  }

  Future<void> toggleStar(String postId) async {
    try {
      await PostService.starPost(postId);
      if (_post != null && _post!.id == postId) {
        _post!.isStarred = !_post!.isStarred;
        if (_post!.isStarred) {
          _starredPosts.add(postId);
        } else {
          _starredPosts.remove(postId);
        }
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      print('Error toggling star: $e');
      notifyListeners();
    }
  }

  Future<void> updatePost(String postId, String title, String content, BuildContext context) async {
    try {
      if (_post != null) {
        UserInfo userInfo = await UserInfo.initialize();
        Post updatedPost = await PostService.updatePost(userInfo, postId, title, content);
        _post = updatedPost;
        notifyListeners();

        // Cập nhật PostProvider
        final postProvider = Provider.of<PostProvider>(context, listen: false);
        postProvider.updatePost(_post!);
      }
    } catch (e) {
      _error = e.toString();
      print('Error updating post: $e');
      notifyListeners();
    }
  }

  Future<void> deletePost(String postId, BuildContext context) async {
    try {
      await PostService.deletePost(postId);
      _post = null;
      notifyListeners();

      // Cập nhật PostProvider
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider.removePost(postId);
    } catch (e) {
      _error = e.toString();
      print('Error deleting post: $e');
      notifyListeners();
    }
  }

  Future<void> addComment(String postId, String content, int? parentId, BuildContext context) async {
    try {
      if (_post != null) {
        final userInfo = await UserInfo.initialize();
        Comment newComment = await PostService.createComment(userInfo, postId, content, parentId);
        _post!.comments.insert(0, newComment);
        _post!.commentsCount++;
        print('New comment added: ${newComment.id}');
        print('Total comments count: ${_post!.commentsCount}');
        print('Post ID: ${newComment.content}');
        notifyListeners();

        // Cập nhật PostProvider
        final postProvider = Provider.of<PostProvider>(context, listen: false);
        postProvider.updatePost(_post!);
      }
    } catch (e) {
      _error = e.toString();
      print('Error adding comment: $e');
      notifyListeners();
    }
  }

  Future<void> updateComment(int commentId, String content, BuildContext context) async {
    try {
      if (_post != null) {
        final userInfo = await UserInfo.initialize();
        Comment updatedComment = await PostService.updateComment(userInfo, commentId, content);
        int index = _post!.comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          _post!.comments[index] = updatedComment;
          notifyListeners();

          // Cập nhật PostProvider
          final postProvider = Provider.of<PostProvider>(context, listen: false);
          postProvider.updatePost(_post!);
        }
      }
    } catch (e) {
      _error = e.toString();
      print('Error updating comment: $e');
      notifyListeners();
    }
  }

  Future<void> deleteComment(int commentId, BuildContext context) async {
    try {
      if (_post != null) {
        await PostService.deleteComment(commentId);
        _post!.comments.removeWhere((c) => c.id == commentId);
        _post!.commentsCount--;
        notifyListeners();

        // Cập nhật PostProvider
        final postProvider = Provider.of<PostProvider>(context, listen: false);
        postProvider.updatePost(_post!);
      }
    } catch (e) {
      _error = e.toString();
      print('Error deleting comment: $e');
      notifyListeners();
    }
  }
}