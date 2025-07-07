import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../screens/auth/login/login_screen.dart';
import '../utils/app_const.dart';
import '../utils/nav_utail.dart';
import '../utils/shared_preferences.dart';

class ApiService {
  static Dio? _dio;

  static Dio? getDio() {
    if (_dio == null) {
      BaseOptions options = BaseOptions(baseUrl: AppConst.baseUrlApi,
          headers: {
            Headers.contentTypeHeader : Headers.jsonContentType,
            'X-API-KEY': AppConst.apiKeyAuth,
          });

      _dio = Dio(options);

      _dio!.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {

        var token = await SPUtill.getValue(SPUtill.keyAccessToken);
        if (token != null) {
          options.headers = {
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            'Authorization': "${AppConst.bearerToken} $token",
            'X-API-KEY': AppConst.apiKeyAuth,
          };
        }
        return handler.next(options);
      }, onResponse: (response, handler) {
        if (kDebugMode) {
          print('response data : ${response.data}');
        }
        return handler.next(response);
      }, onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          // logOutFunctionality(navigatorKey.currentContext);
        }
        if (kDebugMode) {
          print('Error Response : ${e.response}');
          print('Error message : ${e.message}');
          print('Error type : ${e.type.name}');
        }
        return handler.next(e);
      }));
    }
    return _dio;
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static logOutFunctionality(context) async {
    await SPUtill.deleteKey(SPUtill.keyAccessToken);
    await SPUtill.deleteKey(SPUtill.keyRefreshToken);
    await SPUtill.deleteKey(SPUtill.keyUserId);
    await SPUtill.deleteKey(SPUtill.keyProfileImage);
    await SPUtill.deleteKey(SPUtill.keyCheckInID);
    await SPUtill.deleteKey(SPUtill.keyName);
    await SPUtill.deleteKey(SPUtill.keyIsAdmin);
    await SPUtill.deleteKey(SPUtill.keyIsUser);

    NavUtil.navigateAndClearStack(context, const LoginScreen());
  }
}
