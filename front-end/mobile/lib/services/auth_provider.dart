import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProviderCustom with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  // Kiểm tra trạng thái đăng nhập khi khởi động app
  Future<void> checkAuthState() async {
    _user = _auth.currentUser;
    final prefs = await SharedPreferences.getInstance();
    if (_user != null) {
      // Lưu thông tin user vào SharedPreferences
      await prefs.setString('user_name', _user?.displayName ?? '');
      await prefs.setString('user_email', _user?.email ?? '');
      await prefs.setString('user_id', _user?.uid ?? '');
      await prefs.setString('user_photo', _user?.photoURL ?? '');
    }
    notifyListeners();
  }

  // Đăng nhập với Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      // Lưu thông tin user vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _user?.displayName ?? '');
      await prefs.setString('user_email', _user?.email ?? '');
      await prefs.setString('user_id', _user?.uid ?? '');
      await prefs.setString('user_photo', _user?.photoURL ?? '');

      notifyListeners();
      return userCredential;
    } catch (error) {
      throw Exception(error);
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;

      // Xóa thông tin user từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }
}