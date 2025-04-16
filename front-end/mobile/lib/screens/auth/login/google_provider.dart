import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../../utils/app_const.dart';
import '../../../utils/shared_preferences.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String baseUrl = AppConst.baseUrlApi;

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/google-mobile'),
        headers: {
          'Content-Type': 'application/json',
          'X-Client-Type': 'mobile',
        },
        body: jsonEncode({
          'token': googleAuth.idToken,
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý response từ backend
        final Map<String, dynamic> data = jsonDecode(response.body);
        String jwtToken = data['token'];
        String name = data['name'];
        String role = data['role'];
        String email = data['email'];
        // Lưu token vào local storage (ví dụ: SharedPreferences)
        await saveUserData(jwtToken, name, role, email);

        return jwtToken;
      } else {
        throw Exception('Failed to sign in with Google');
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Hàm lưu token (cần thêm package như shared_preferences)
  Future<void> saveUserData(String token, String name, String role, String email) async {
    SPUtill.setValue(SPUtill.keyAuthToken, token);
    SPUtill.setValue(SPUtill.keyName, name);
    SPUtill.setValue(SPUtill.keyRole, role);
    SPUtill.setValue(SPUtill.keyEmail, email);
  }
}
