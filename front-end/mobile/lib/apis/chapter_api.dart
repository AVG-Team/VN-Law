import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/constants/base_url.dart';


class ChapterApi {

  // Lấy tất cả các chương
  Future<dynamic> getAll() async {
    final url = Uri.parse('$baseUrl/law-service/chapter');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load chapters');
    }
  }

  // Lấy tất cả các chương với phân trang
  Future<dynamic> getAllByPage(Map<String, dynamic> params) async {
    final url = Uri.parse('$baseUrl/law-service/chapter/filter').replace(queryParameters: params);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load chapters by page');
    }
  }

  // Lấy chương theo ID
  Future<dynamic> getById(String id) async {
    final url = Uri.parse('$baseUrl/law-service/chapter/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load chapter by ID');
    }
  }

  // Lấy các chương theo ID môn học
  Future<dynamic> getBySubject(String idSubject) async {
    final url = Uri.parse('$baseUrl/law-service/chapter/subject/$idSubject');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load chapters by subject ID');
    }
  }
}
