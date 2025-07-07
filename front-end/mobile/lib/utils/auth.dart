import 'dart:convert';
import 'package:VNLAW/utils/environment.dart';
import 'package:VNLAW/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthHelper {
  static Future<bool> checkTokenValidity(String token) async {
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

  static Future<String> getAccessToken() async {
    try {
      print('Getting access token...');
      print('${Env.apiAuthUrl}/api/auth/get-access-token-from-refresh-token');
      String refreshToken = await SPUtill.getValue(SPUtill.keyRefreshToken) ?? '';
      if (refreshToken.isEmpty) {
        print('No refresh token found');
        return '';
      }
      final response = await http.post(
        Uri.parse('${Env.apiAuthUrl}/api/auth/get-access-token-from-refresh-token'),
        headers: { 'Content-Type': 'application/json', },
        body: jsonEncode({
          'token': refreshToken,
        }),
      );
      print('Getting access token response: status=${response.statusCode}, body=${response.body}');
      print(response);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        print('Access token response data: '+ data['access_token']);
        SPUtill.setValue(SPUtill.keyAccessToken, data['access_token'] ?? '');
        return data['access_token'] ?? '';
      }
      return '';
    } catch (e) {
      print('Error getting access token: $e');
      return '';
    }
  }

  static Future<String> checkAndGetAccessToken() async {
    String accessToken = await SPUtill.getValue(SPUtill.keyAccessToken) ?? '';
    if (accessToken.isEmpty) {
      accessToken = await getAccessToken();
      if (accessToken.isEmpty) {
        print('Failed to get a valid access token');
      }
    } else {
      bool isTokenExpired = JwtDecoder.isExpired(accessToken);
      if (isTokenExpired) {
        print('Access token is expired, fetching a new one');
        accessToken = await getAccessToken();
        if (accessToken.isEmpty) {
          print('Failed to get a valid access token after expiration');
        }
      } else {
        print('Access token is valid');
      }
    }
    return accessToken;
  }
}