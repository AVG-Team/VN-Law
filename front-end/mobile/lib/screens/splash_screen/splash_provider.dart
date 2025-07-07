import 'dart:convert';
import 'package:VNLAW/utils/auth.dart';
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

  Future<void> initFunction(BuildContext context) async {
    print('initFunction started');
    var token = await SPUtill.getValue(SPUtill.keyRefreshToken);
    print("Bearer token: $token");
    await Future.delayed(const Duration(milliseconds: 1000));

    if (token != null && token.isNotEmpty) {
      bool isValid = await AuthHelper.checkTokenValidity(token);
      print('Token validity: $isValid');
      if (isValid && !_isDisposed) {
        print('Token valid, navigating to dashboard');
        NavUtilAnimation.navigateScreen(
          context,
          AppRoutes.dashboard,
        );
      } else {
        print('Token invalid, deleting token and navigating to login');
        await SPUtill.deleteKey(SPUtill.keyRefreshToken);
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