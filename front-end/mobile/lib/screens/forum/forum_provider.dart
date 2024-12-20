import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/forums/comment_model.dart';
import '../../data/models/forums/forum_post_model.dart';
import '../../services/auth_provider.dart';

class ForumProvider with ChangeNotifier {
  BuildContext? _context;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final AuthProviderCustom _authProvider;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ForumProvider(BuildContext context) {
    _context = context;
    _authProvider = Provider.of<AuthProviderCustom>(context, listen: false);
  }

  List<ForumPost> _posts = [];
  List<ForumPost> _userPosts = [];
  List<ForumPost> _pinnedPosts = [];
  List<ForumPost> _pendingPosts = [];
  List<Comment> _comments = [];
  bool _isLoading = false;

  // Getters
  List<ForumPost> get posts => _posts;
  List<ForumPost> get userPosts => _userPosts;
  List<ForumPost> get pinnedPosts => _pinnedPosts;
  List<ForumPost> get pendingPosts => _pendingPosts;
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  // Load all posts
  // Thêm xử lý tạm thời trong ForumProvider
  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Thử load posts đơn giản hơn trong lúc chờ index
      final simpleQuery = await _firestore
          .collection('posts')
          .where('isApproved', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      _posts = simpleQuery.docs
          .map((doc) => ForumPost.fromFirestore(doc))
          .toList();

      // Phân loại posts sau khi load
      _pinnedPosts = _posts.where((post) => post.isPinned).toList();
      _posts = _posts.where((post) => !post.isPinned).toList();

    } catch (e) {
      print('Error loading posts: $e');
      // Hiển thị thông báo cho người dùng
      if (_context != null && _context!.mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(
            content: Text('Đang xây dựng index, vui lòng thử lại sau...'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm hàm kiểm tra index
  Future<bool> checkIndexStatus() async {
    try {
      // Thử query với index
      await _firestore
          .collection('posts')
          .where('isPinned', isEqualTo: true)
          .where('isApproved', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      return true;
    } catch (e) {
      if (e is FirebaseException && e.code == 'failed-precondition') {
        return false; // Index chưa sẵn sàng
      }
      rethrow;
    }
  }



  // Create new post
  Future<void> createPost(String title, String content) async {
    try {
      final user = _authProvider.userModel;
      if (user == null) {
        throw FirebaseException(
          plugin: 'forum',
          code: 'unauthenticated',
          message: 'Bạn cần đăng nhập để tạo bài viết',
        );
      }

      if (title.isEmpty || content.isEmpty) {
        throw FirebaseException(
          plugin: 'forum',
          code: 'invalid-input',
          message: 'Tiêu đề và nội dung không được để trống',
        );
      }

      final post = ForumPost(
        id: '',
        title: title,
        content: content,
        authorId: user.uid!,
        authorName: user.displayName!,
        authorPhotoURL: user.photoURL!,
        createdAt: DateTime.now(),
        isApproved: user.isAdmin,
        likes: [],
        commentCount: 0,
        isPinned: false,
      );

      final docRef = await _firestore.collection('posts').add(post.toMap());
      await docRef.update({'id': docRef.id});
      await loadPosts();

      if (_context != null && _context!.mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(
            content: Text('Bài viết đã được tạo thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'Bạn không có quyền thực hiện thao tác này';
          break;
        case 'unauthenticated':
          errorMessage = 'Bạn cần đăng nhập để tạo bài viết';
          break;
        default:
          errorMessage = 'Đã xảy ra lỗi khi tạo bài viết: ${e.message}';
      }
      if (_context != null && _context!.mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (kDebugMode) {
        print('Error creating post: $e');
      }
      rethrow;
    } catch (e) {
      if (_context != null && _context!.mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi không xác định: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (kDebugMode) {
        print('Error creating post: $e');
      }
      rethrow;
    }
  }

  // Toggle like on post
  Future<void> toggleLike(String postId) async {
    final userId = _authProvider.userModel!.uid;
    final postRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);
      final post = ForumPost.fromFirestore(postDoc);

      List<String> likes = List.from(post.likes);
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId!);
      }

      transaction.update(postRef, {'likes': likes});
    });

    await loadPosts();
  }

  // Approve post
  Future<void> approvePost(String postId) async {
    await _firestore.collection('posts').doc(postId).update({
      'isApproved': true,
    });
    await loadPosts();
    await loadPendingPosts();
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
    await loadPosts();
    await loadPendingPosts();
  }

  // Pin/Unpin post
  Future<void> togglePin(String postId, bool isPinned) async {
    if (isPinned) {
      final pinnedPosts = await _firestore
          .collection('posts')
          .where('isPinned', isEqualTo: true)
          .get();

      if (pinnedPosts.docs.length >= 5) {
        throw Exception('Không thể ghim quá 5 bài viết');
      }
    }

    await _firestore.collection('posts').doc(postId).update({
      'isPinned': isPinned,
    });
    await loadPosts();
  }

  // Load comments for a post
  Future<void> loadComments(String postId) async {
    final snapshot = await _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .get();

    _comments = snapshot.docs
        .map((doc) => Comment.fromFirestore(doc))
        .toList();

    notifyListeners();
  }

  // Add comment
  Future<void> addComment(String postId, String content) async {
    final user = _authProvider.userModel!;
    final comment = Comment(
      id: '',
      postId: postId,
      content: content,
      authorId: user.uid!,
      authorName: user.displayName!,
      authorPhotoURL: user.photoURL!,
      createdAt: DateTime.now(),
    );

    // Add comment
    await _firestore.collection('comments').add(comment.toMap());

    // Update comment count
    await _firestore.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(1),
    });

    await loadComments(postId);
    await loadPosts();
  }

  // Delete comment
  Future<void> deleteComment(String postId, String commentId) async {
    await _firestore.collection('comments').doc(commentId).delete();

    await _firestore.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(-1),
    });

    await loadComments(postId);
    await loadPosts();
  }

  // Load pending posts for admin
  Future<void> loadPendingPosts() async {
    final snapshot = await _firestore
        .collection('posts')
        .where('isApproved', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();

    _pendingPosts = snapshot.docs
        .map((doc) => ForumPost.fromFirestore(doc))
        .toList();

    notifyListeners();
  }
}
