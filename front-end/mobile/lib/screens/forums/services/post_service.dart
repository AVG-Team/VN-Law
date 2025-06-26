import 'dart:convert';
import 'package:VNLAW/utils/app_const.dart';
import 'package:VNLAW/utils/auth.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/forum/post.dart';
import '../../../data/models/user_info.dart';

class PostService {
  static String baseUrl = AppConst.apiForumUrl;

  static Future<List<Post>> getPosts({String filter = 'all', int page = 1, int pageSize = 10}) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/posts?filter=$filter&page=$page&page_size=$pageSize'),
      headers: {'Authorization': 'Bearer $accessToken', 'Accept': 'application/json; charset=utf-8'},
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final postsJson = jsonResponse['data']['posts'] as List<dynamic>;
        return postsJson.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format: Expected a Map with "data.posts"');
      }
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  static Future<Post> getPost(String id) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/posts/$id'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        print(jsonResponse['data']['post'].toString());
        final postJson = jsonResponse['data']['post'] as Map<String, dynamic>;
        return Post.fromJson(postJson);
      } else {
        throw Exception('Invalid response format: Expected a Map with "data.posts"');
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<void> createPost(String title, String content, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'content': content}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create post');
    }
  }

  static Future<List<String>> getLikedPostIds() async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me/likes'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final postsJson = jsonResponse['data']['posts'] as List<dynamic>;
        return postsJson.map((post) => post['id'] as String).toList();
      } else {
        throw Exception('Invalid response format: Expected a Map with "data.posts"');
      }
    } else {
      throw Exception('Failed to load liked posts: ${response.statusCode}');
    }
  }

  static Future<List<String>> getStarredPostIds() async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me/stars'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final postsJson = jsonResponse['data']['posts'] as List<dynamic>;
        return postsJson.map((post) => post['id'] as String).toList();
      } else {
        throw Exception('Invalid response format: Expected a Map with "data.posts"');
      }
    } else {
      throw Exception('Failed to load stars posts: ${response.statusCode}');
    }
  }

  static Future<bool> likePost(String postId) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/$postId/like'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to like post');
    }

    return response.statusCode == 200;
  }

  static Future<bool> starPost(String postId) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/$postId/star'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to like post');
    }

    return response.statusCode == 200;
  }

  static Future<bool> pinPost(String postId) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/$postId/pin'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to pin post');
    }

    return response.statusCode == 200;
  }

  static Future<bool> unpinPost(String postId) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/$postId/unpin'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to pin post');
    }

    return response.statusCode == 200;
  }

  static Future<Post> updatePost(UserInfo userInfo, String postId, String title, String content) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    String name = userInfo.name;
    final response = await http.patch(
      Uri.parse('$baseUrl/api/posts/$postId'),
      headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'content': content}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update post');
    }

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final postJson = jsonResponse['data']['post'] as Map<String, dynamic>;
        postJson['name'] = name;
        return Post.fromJson(postJson);
      } else {
        throw Exception('Invalid response format: Expected a Map with "data.post"');
      }
    }

    throw Exception('Failed to update post');
  }

  static Future<bool> deletePost(String postId) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/posts/$postId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }

    return response.statusCode == 200;
  }

  static Future<Comment> createComment(UserInfo userInfo, String postId, String content, int? parentId) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    final name = userInfo.name;
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/$postId/comments'),
      headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
      body: jsonEncode({'content': content, if (parentId != null) 'parentId': parentId,}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create comment');
    }

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final commentJson = jsonResponse['data']['comment'] as Map<String, dynamic>;
        commentJson['name'] = name;
        return Comment.fromJson(commentJson);
      } else {
        throw Exception('Invalid response format: Expected a Map with "data.comment"');
      }
    }

    throw Exception('Failed to create comment');
  }

  static Future<Comment> updateComment(UserInfo userInfo, int commentId, String content) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    String name = userInfo.name;
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/comments/$commentId'),
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update comment');
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
          final commentJson = jsonResponse['data']['comment'] as Map<String, dynamic>;
          commentJson['name'] = name;
          return Comment.fromJson(commentJson);
        } else {
          throw Exception('Invalid response format: Expected a Map with "data.comment"');
        }
      }
    } catch (e) {
      print('Error updating comment: $e');
      throw Exception('Failed to update comment');
    }

    throw Exception('Failed to update comment');
  }

  static Future<bool> deleteComment(int commentId) async {
    String accessToken = await AuthHelper.checkAndGetAccessToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/comments/$commentId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }

    return response.statusCode == 200;
  }
}