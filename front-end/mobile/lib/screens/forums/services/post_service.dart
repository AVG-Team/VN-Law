import 'dart:convert';
import 'package:VNLAW/utils/app_const.dart';
import 'package:VNLAW/utils/auth.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/forum/post.dart';

class PostService {
  static String baseUrl = AppConst.apiForumUrl;

  static Future<List<Post>> getPosts(String token, {String filter = 'all', int page = 1, int pageSize = 10}) async {
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

  // static Future<List<Post>> getMyPosts(String token) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/users/me/posts'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );
  //   if (response.statusCode == 200) {
  //     List jsonList = jsonDecode(response.body);
  //     return jsonList.map((json) => Post.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load my posts');
  //   }
  // }

  static Future<Post> getPost(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/posts/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
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

  static Future<List<String>> getLikedPostIds(String token) async {
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

  static Future<List<String>> getStaredPostIds(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me/stars'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final posts = jsonDecode(response.body)['data']['posts'] as List<dynamic>;
      return posts.map((post) => post['id'] as String).toList();
    } else {
      throw Exception('Failed to load liked posts');
    }
  }

  static Future<bool> likePost(String postId, String token) async {
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

  static Future<void> starPost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/star'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to like post');
    }
  }

  static Future<void> pinPost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/pin'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to pin post');
    }
  }

  static Future<void> unpinPost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/unpin'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to pin post');
    }
  }

  static Future<void> deletePost(String postId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$postId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}