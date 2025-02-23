import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String baseUrl = 'YOUR_BACKEND_URL';

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Gửi token đến backend
      final response = await http.post(
        Uri.parse('$baseUrl/api/oauth2/google'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': googleAuth.idToken,
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý response từ backend
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Lưu token vào local storage
        await saveToken(data['token']);
        return data;
      } else {
        throw Exception('Failed to sign in with Google');
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
}
