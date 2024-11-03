import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/constants/baseUrl.dart';


class ArticleApi {

  Future<dynamic> getByChapterId(String chapterId) async {
    final url = Uri.parse('$baseUrl/law-service/article/chapter/$chapterId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load article by chapter ID');
    }
  }

  Future<dynamic> getTreeArticle(String articleId) async {
    final url = Uri.parse('$baseUrl/law-service/article/tree/$articleId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tree article');
    }
  }

  Future<dynamic> getAllByPage(Map<String, dynamic> params) async {
    final url = Uri.parse('$baseUrl/law-service/article/filter');
    final response = await http.get(url.replace(queryParameters: params));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load articles by page');
    }
  }
}
