import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/constants/base_url.dart';

class VbqpplApi {
  Future<dynamic> getAllByPage(Map<String, dynamic> params) async {
    final url = Uri.parse('$baseUrl/law-service/vbqppl').replace(queryParameters: params);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load vbqppl by page');
    }
  }

  Future<dynamic> getById(String vbqpplId) async {
    final url = Uri.parse('$baseUrl/law-service/vbqppl/$vbqpplId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load vbqppl by ID');
    }
  }

  // Lấy tất cả các vbqppl
  Future<dynamic> getAll() async {
    final url = Uri.parse('$baseUrl/law-service/vbqppl/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load all vbqppl');
    }
  }

  Future<dynamic> filter(Map<String, dynamic> params) async {
    final url = Uri.parse('$baseUrl/law-service/vbqppl/filter').replace(queryParameters: params);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to filter vbqppl');
    }
  }
}