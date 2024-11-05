import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/constants/base_url.dart';


class SubjectApi {
  // Lấy tất cả các môn học với phân trang
  Future<dynamic> getAllByPage(Map<String, dynamic> params) async {
    final url = Uri.parse('$baseUrl/law-service/subject').replace(queryParameters: params);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load subjects by page');
    }
  }

  // Lấy tất cả các môn học
  Future<dynamic> getAll() async {
    final url = Uri.parse('$baseUrl/law-service/subject');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  // Lấy môn học theo ID
  Future<dynamic> getById(String id) async {
    final url = Uri.parse('$baseUrl/law-service/subject/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load subject by ID');
    }
  }

  // Lấy môn học theo ID chủ đề
  Future<dynamic> getByTopic(String idTopic) async {
    final url = Uri.parse('$baseUrl/law-service/subject/topic/$idTopic');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load subjects by topic ID');
    }
  }
}
