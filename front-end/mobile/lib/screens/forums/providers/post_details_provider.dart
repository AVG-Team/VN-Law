import 'package:flutter/material.dart';
import '../../../data/models/forum/post.dart';
import '../services/post_service.dart';

class PostDetailsProvider with ChangeNotifier {
  Post? _post;
  bool _isLoading = false;
  String? _error;
  List<String> _likedPosts = [];

  Post? get post => _post;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get likedPosts => _likedPosts;

  Future<void> fetchPost(String id, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _likedPosts = await PostService.getLikedPostIds(token);
      _post = await PostService.getPost(id, token);
      _post!.isLiked = _likedPosts.contains(_post!.id);
    } catch (e) {
      _error = e.toString();
      _post = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String postId, String token) async {
    try {
      await PostService.likePost(postId, token);
      if (_post != null) {
        _post!.isLiked = !_post!.isLiked;
        _post!.likes += _post!.isLiked ? 1 : -1;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> togglePin(String postId, String token) async {
    try {
      if (_post != null) {
        if (_post!.isPinned) {
          await PostService.unpinPost(postId, token);
          _post!.isPinned = false;
        } else {
          await PostService.pinPost(postId, token);
          _post!.isPinned = true;
        }
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deletePost(String postId, String token) async {
    try {
      await PostService.deletePost(postId, token);
      _post = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}