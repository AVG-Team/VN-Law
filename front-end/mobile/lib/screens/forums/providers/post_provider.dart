import 'package:flutter/material.dart';
import '../../../data/models/forum/post.dart';
import '../../../data/models/user_info.dart';
import '../services/post_service.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isFetchingPosts = false; // Trạng thái cho fetchPosts
  bool _isFetchingLikedPosts = false; // Trạng thái cho fetchLikedPosts
  bool _isLikingPost = false; // Trạng thái cho likePost
  List<String> _likedPosts = [];
  bool _isLikedPostsLoaded = false;
  bool _hasMore = true;
  String _filter = 'all';
  int _page = 1;
  final int _pageSize = 10;

  List<Post> get posts => _posts;
  bool get isFetchingPosts => _isFetchingPosts;
  bool get isFetchingLikedPosts => _isFetchingLikedPosts;
  bool get isLikingPost => _isLikingPost;
  List<String> get likedPosts => _likedPosts;
  bool get hasMore => _hasMore;

  Future<void> fetchPosts({String filter = 'all', int page = 1, int pageSize = 10}) async {
    if (_isFetchingPosts) return;
    if (page == 1) {
      _posts.clear(); // Xóa danh sách khi lấy trang 1
      _hasMore = true;
    }
    _isFetchingPosts = true;
    notifyListeners();
    try {
      final userInfo = await UserInfo.initialize();
      if (userInfo.accessToken.isNotEmpty) {
        await _loadLikedPosts();
        final fetchedPosts = await PostService.getPosts(filter: filter, page: page, pageSize: pageSize);
        _posts.addAll(fetchedPosts);
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
      _isFetchingPosts = false;
      notifyListeners();
    }
  }

  Future<void> fetchLikedPosts() async {
    if (_isFetchingLikedPosts) return;
    _isFetchingLikedPosts = true;
    notifyListeners();
    try {
      _likedPosts = await PostService.getLikedPostIds();
      _isLikedPostsLoaded = true;
      for (var post in _posts) {
        post.isLiked = _likedPosts.contains(post.id);
      }
    } catch (e) {
      print(e);
    } finally {
      _isFetchingLikedPosts = false;
      notifyListeners();
    }
  }

  Future<void> _loadLikedPosts() async {
    if (_isLikedPostsLoaded) return; // Không gọi lại nếu đã tải
    _isFetchingLikedPosts = true;
    notifyListeners();
    try {
      _likedPosts = await PostService.getLikedPostIds();
      _isLikedPostsLoaded = true;
    } catch (e) {
      print('Error loading liked posts: $e');
    } finally {
      _isFetchingLikedPosts = false;
      notifyListeners();
    }
  }

  Future<void> likePost(String postId) async {
    if (_isLikingPost) return;
    _isLikingPost = true;
    notifyListeners();
    try {
      // Gọi API để like/unlike post
      bool toggleLikeSuccess = await PostService.likePost(postId);
      if (toggleLikeSuccess == true) {
        // Cập nhật trạng thái likedPosts
        if (!_likedPosts.contains(postId)) {
          _likedPosts.add(postId);
        } else {
          _likedPosts.remove(postId);
        }
        _isLikedPostsLoaded = false;
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
      _isLikingPost = false;
      notifyListeners();
    }
  }

  void updatePost(Post updatedPost) {
    final index = _posts.indexWhere((p) => p.id == updatedPost.id);
    if (index != -1) {
      _posts[index] = updatedPost;
      notifyListeners();
    }
  }

  void removePost(String postId) {
    _posts.removeWhere((p) => p.id == postId);
    notifyListeners();
  }
}