import 'package:flutter/material.dart';
import '../../../data/models/forum/post.dart';
import '../../../data/models/user_info.dart';
import '../services/post_service.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  List<String> _likedPosts = [];
  bool _hasMore = true;
  String _filter = 'all';
  int _page = 1;
  final int _pageSize = 10;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  List<String> get likedPosts => _likedPosts;
  bool get hasMore => _hasMore;

  Future<void> fetchPosts({String filter = 'all', int page = 1, int pageSize = 10}) async {
    if (page == 1) {
      _posts.clear(); // Xóa danh sách khi lấy trang 1
      _hasMore = true;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final userInfo = await UserInfo.initialize();
      if (userInfo.accessToken.isNotEmpty) {
        final fetchedPosts = await PostService.getPosts(userInfo.accessToken, filter: filter, page: page, pageSize: pageSize);
        _posts.addAll(fetchedPosts);
        _likedPosts = await PostService.getLikedPostIds(userInfo.accessToken);
        for (var post in _posts) {
          post.isLiked = _likedPosts.contains(post.id);
        }
        if (fetchedPosts.length < pageSize) _hasMore = false;
        _filter = filter;
        _page = page;
      }
    } catch (e) {
      print('Error fetching posts: $e');
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLikedPosts(String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      _likedPosts = await PostService.getLikedPostIds(token);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> likePost(String postId) async {
    _isLoading = true;
    notifyListeners();
    final userInfo = await UserInfo.initialize();
    try {
      // Gọi API để like/unlike post
      bool toggleLikeSuccess = await PostService.likePost(postId, userInfo.accessToken);
      if (toggleLikeSuccess == true) {
        // Cập nhật trạng thái likedPosts
        if (!_likedPosts.contains(postId)) {
          _likedPosts.add(postId);
        } else {
          _likedPosts.remove(postId);
        }
        // Cập nhật post trong danh sách
        for (var post in _posts) {
          if (post.id == postId) {
            post.isLiked = !post.isLiked;
            break;
          }
        }
      } else {
        throw Exception('Failed to like post: $postId');
      }
    } catch (e) {
      print('Error liking post: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}