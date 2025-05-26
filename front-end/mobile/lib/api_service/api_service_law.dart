import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../data/models/vbqppl/article.dart';
import '../data/models/vbqppl/chapter.dart';
import '../data/models/vbqppl/subject.dart';
import '../data/models/vbqppl/topic.dart';

class ApiServiceLaw {
  static const String baseUrl = 'http://10.0.2.2:9002/law/api';

  // Lấy danh sách topic
  Future<List<Topic>> getTopics() async {
    final response = await http.get(
        Uri.parse('$baseUrl/topic'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> topicData = responseData['data'];
      return topicData.map((json) => Topic.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách Topic');
    }
  }

  // Lấy danh sách subject theo topic ID
  Future<List<Subject>> getSubjectsByTopic(String topicId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/subject/topic/$topicId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> subjectData = responseData['data'];
      return subjectData.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách Subject');
    }
  }

  // Lấy danh sách chapter theo subject ID
  Future<List<Chapter>> getChaptersBySubject(String subjectId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/chapter/subject/$subjectId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> chapterData = responseData['data'];
      return chapterData.map((json) => Chapter.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách Chapter');
    }
  }

  // Lấy danh sách article theo chapter ID với phân trang
  Future<Map<String, dynamic>> getArticlesByChapter(String chapterId, int page, int size) async {
    String url = '$baseUrl/article/$chapterId?page=$page&size=$size';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      final Map<String, dynamic> articleData = responseData['data'];
      final List<dynamic> content = articleData['content'];

      return {
        'articles': content.map((json) => Article.fromJson(json)).toList(),
        'totalPages': articleData['totalPages'],
        'totalElements': articleData['totalElements'],
        'currentPage': articleData['number'],
      };
    } else {
      throw Exception('Không thể tải danh sách Article');
    }
  }

//   Theme
   loading(context) {
    return Center(
      child: SpinKitRipple(
        color: Theme.of(context).primaryColor, // Sử dụng màu chủ đạo
        size: 50.0, // Kích thước animation
      ),
    );
  }
}
