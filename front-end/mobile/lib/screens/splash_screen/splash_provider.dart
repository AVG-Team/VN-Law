import 'dart:convert';
import 'package:VNLAW/utils/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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
      final response = await http.post(
        Uri.parse('${Env.keycloakUrl}/realms/vnlaw/protocol/openid-connect/token/introspect'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': token,
          'client_id': Env.keycloakId,
          'client_secret': Env.keycloakSecret,
        },
      );
      print('Token introspection response: status=${response.statusCode}, body=${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['active'] == true;
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

    if (token != null && token.isNotEmpty) {
      bool isValid = await checkTokenValidity(token);
      print('Token validity: $isValid');
      if (isValid && !_isDisposed) {
        print('Token valid, navigating to dashboard');
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      } else {
        print('Token invalid, deleting token and navigating to login');
        await SPUtill.deleteKey(SPUtill.keyAuthToken);
        if (!_isDisposed) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.loginProvider);
        }
      }
    } else {
      print('No token found, navigating to login');
      if (!_isDisposed) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.loginProvider);
      }
    }
    if (!_isDisposed) notifyListeners();
  }
}