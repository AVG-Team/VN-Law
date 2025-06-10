import 'dart:convert';
import 'package:VNLAW/utils/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/nav_util_animation.dart';
import '../../utils/routes.dart';
import '../../utils/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  bool isLoading = false;
  bool _isDisposed = false;

  SplashProvider(BuildContext context) {
    print('SplashProvider initialized');
    initFunction(context);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<bool> checkTokenValidity(String token) async {
    try {
      print('Checking token validity...');
      print('${Env.apiAuthUrl}/api/auth/check-token-keycloak');
      final response = await http.post(
        Uri.parse('${Env.apiAuthUrl}/api/auth/check-token-keycloak'),
        headers: { 'Content-Type': 'application/json', },
        body: jsonEncode({
          'token': token,
        }),
      );
      print('Token introspection response: status=${response.statusCode}, body=${response.body}');
      print(response);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return data == "OK";
      }
      return false;
    } catch (e) {
      print('Error checking token validity: $e');
      return false;
    }
  }

  Future<void> initFunction(BuildContext context) async {
    print('initFunction started');
    var token = await SPUtill.getValue(SPUtill.keyAuthToken);
    print("Bearer token: $token");
    await Future.delayed(const Duration(milliseconds: 1000));

    if (token != null && token.isNotEmpty) {
      bool isValid = await checkTokenValidity(token);
      print('Token validity: $isValid');
      if (isValid && !_isDisposed) {
        print('Token valid, navigating to dashboard');
        NavUtilAnimation.navigateScreen(
          context,
          AppRoutes.dashboard,
        );
      } else {
        print('Token invalid, deleting token and navigating to login');
        await SPUtill.deleteKey(SPUtill.keyAuthToken);
        if (!_isDisposed) {
          NavUtilAnimation.navigateScreen(
            context,
            AppRoutes.loginProvider,
          );
        }
      }
    } else {
      print('No token found, navigating to login');
      if (!_isDisposed) {
        NavUtilAnimation.navigateScreen(
          context,
          AppRoutes.loginProvider,
        );
      }
    }
    if (!_isDisposed) notifyListeners();
  }
}