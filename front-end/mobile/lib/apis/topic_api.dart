import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/constants/base_url.dart';


class TopicApi {

  // Lấy tất cả các chủ đề
  Future<Map<String, dynamic>> getAll() async {
    final url = Uri.parse('$baseUrl/law-service/topic');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load topics');
    }
  }

  // Lấy chủ đề theo ID
  Future<dynamic> getById(String id) async {
    final url = Uri.parse('$baseUrl/law-service/topic/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load topic by ID');
    }
  }
}
