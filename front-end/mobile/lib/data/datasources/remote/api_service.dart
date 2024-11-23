import 'package:dio/dio.dart';
import '../../../core/config/environment.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = Env.apiBaseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Env.apiKey}',
    };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }
}