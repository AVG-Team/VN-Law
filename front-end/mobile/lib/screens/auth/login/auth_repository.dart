import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/environment.dart';
import 'keycloak_response.dart';

class AuthRepository {
  static Future<KeycloakResponse<Map<String, dynamic>>> exchangeToken(String provider, String token) async {
    final data = {
      'grant_type': 'urn:ietf:params:oauth:grant-type:token-exchange',
      'subject_token_type': 'urn:ietf:params:oauth:token-type:access_token',
      'client_id': Env.keycloakId,
      'client_secret': Env.keycloakSecret,
      'subject_issuer': provider,
      'subject_token': token,
    };

    print(data.toString());

    try {
      final response = await http.post(
        Uri.parse('${Env.keycloakUrl}/realms/vnlaw/protocol/openid-connect/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data.map((key, value) => MapEntry(key, value.toString())),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return KeycloakResponse(
          httpCode: response.statusCode,
          result: true,
          data: json,
          message: 'Token exchange successful',
        );
      } else {
        return KeycloakResponse(
          httpCode: response.statusCode,
          result: false,
          message: 'Token exchange failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      return KeycloakResponse(
        result: false,
        message: 'Error: $e',
      );
    }
  }

  // Giữ nguyên phương thức getLogin hiện tại nếu có
  static Future<KeycloakResponse> getLogin(dynamic bodyLogin) async {
    // Logic hiện tại của bạn
    return KeycloakResponse(result: false, message: 'Not implemented');
  }
}