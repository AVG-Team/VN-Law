import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../api_service/api_response.dart';
import '../../utils/app_const.dart';
import '../models/news_response/response_news.dart';

class NewsRepository {
  static String convertCategory(String category) {
    switch (category) {
      case "Pháp luật":
        return 'politics';
      case "Đời sống":
        return 'top';
      case "An Ninh":
        return 'politics';
      default:
        return 'unknown';
    }
  }

  // Sửa lại phương thức getNewsArticles
  static Future<ApiResponse<ResponseNews>> getNewsArticles({String? category}) async {
    try {
      EasyLoading.show(
        status: 'Đang tải dữ liệu...',
        maskType: EasyLoadingMaskType.custom
      );
      String url = category != null
          ? "${AppConst.baseUrlNews}&category=${convertCategory(category)}"
          : AppConst.baseUrlNews;
      final response = await http.get(Uri.parse(url));
      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        var obj = responseNewsFromJson(utf8Response);
        return ApiResponse(
          result: obj.status,
          message: obj.message,
          data: obj,
        );
      } else {
        final utf8Response = utf8.decode(response.bodyBytes);
        var obj = responseNewsFromJson(utf8Response);
        return ApiResponse(
          result: obj.status,
          message: obj.message,
          data: obj,
        );
      }
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      return ApiResponse(
        result: false,
        message: "Get Data Failed ${e.message}",
      );
    } catch (e) {
      EasyLoading.dismiss();
      return ApiResponse(
        result: false,
        message: "Unexpected error: $e",
      );
    }
  }
}
