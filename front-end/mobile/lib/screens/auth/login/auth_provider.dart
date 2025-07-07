import 'dart:convert';

import 'package:VNLAW/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../utils/routes.dart';
import '../../../utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final String apiUrlAuth = AppConst.apiAuthUrl;


  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OverlayEntry? _overlayEntry;

  // Show loading overlay
  void _showLoadingOverlay(BuildContext context) {
    _isLoading = true;
    notifyListeners();

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            color: Colors.black.withOpacity(0.4),
            dismissible: false,
          ),
          Center(
            child: SpinKitCircle(
              color: Colors.cyanAccent[400],
              size: 60.0,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // Hide loading overlay
  void _hideLoadingOverlay() {
    _isLoading = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    notifyListeners();
  }

  // Đăng nhập bằng email và mật khẩu
  Future<void> loginWithEmail(BuildContext context) async {
    _showLoadingOverlay(context);
    final email = emailTextController.text;
    final password = passwordTextController.text;
    try {
      final response = await http.post(
        Uri.parse('$apiUrlAuth/api/auth/authenticate'),
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      print(jsonDecode(response.body));
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        final keycloakToken = data;
        await _processKeycloakToken(context, keycloakToken);
        Fluttertoast.showToast(
          msg: 'Đăng nhập thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        resetTextField();
      } else {
        try {
          final errorData = jsonDecode(response.body)['data'];
          if (errorData['error'] == 'invalid_grant') {
            Fluttertoast.showToast(
              msg: 'Vui lòng xác minh email của bạn trước khi đăng nhập',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          } else {
            Fluttertoast.showToast(
              msg: 'Đăng nhập thất bại: Sai email hoặc mật khẩu',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        } catch (e) {
          // Nếu body không phải JSON hoặc lỗi khác
          Fluttertoast.showToast(
            msg: 'Đăng nhập thất bại: Lỗi không xác định',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      Fluttertoast.showToast(
        msg: 'Có lỗi xảy ra, vui lòng thử lại',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _hideLoadingOverlay();
    }
  }

  // Đăng nhập bằng Google
  Future<bool> loginWithGoogle(BuildContext context) async {
    bool isSuccess = false;
    _showLoadingOverlay(context);
    try {
      // Gọi Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng hủy đăng nhập
        _hideLoadingOverlay();
        return isSuccess;
      }

      // Lấy access token từ Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String accessToken = googleAuth.accessToken!;

      // Trao đổi token với Keycloak
      final response = await http.post(
        Uri.parse('$apiUrlAuth/api/auth/google-token'),
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode({
          'provider': "google",
          'token': accessToken,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Keycloak token: $data");
        final keycloakToken = data['data'];

        // Xử lý thông tin từ Keycloak token
        await _processKeycloakToken(context, keycloakToken);

        Fluttertoast.showToast(
          msg: "Đăng nhập thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        resetTextField();
        print("Đăng nhập thành công");
        isSuccess = true;
      } else {
        Fluttertoast.showToast(
          msg: jsonDecode(response.body)['message'] ?? "Đăng nhập thất bại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Lỗi khi đăng nhập bằng Google: $e');
      Fluttertoast.showToast(
        msg: "Đăng nhập thất bại",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _hideLoadingOverlay();
    }
    return isSuccess;
  }

  // Register user
  Future<void> registerUser(BuildContext context) async {
    _showLoadingOverlay(context);
    final email = emailTextController.text;
    final password = passwordTextController.text;
    final name = nameTextController.text;

    try {
      // Bước 1: Tạo người dùng
      final createUserResponse = await http.post(
        Uri.parse('$apiUrlAuth/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'username': email,
          'firstName': name,
          'password': password,
        }),
      );

      if (createUserResponse.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        resetTextField();
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      } else {
        Fluttertoast.showToast(
          msg: 'Đăng ký thất bại: ${createUserResponse.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Lỗi đăng ký: $e');
      Fluttertoast.showToast(
        msg: 'Có lỗi xảy ra, vui lòng thử lại: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _hideLoadingOverlay();
    }
  }

  // Hàm reset mật khẩu mới
  Future<void> resetPassword(BuildContext context, email) async {
    _showLoadingOverlay(context);
    try {
      print("email : " + email);

      final response = await http.post(
        Uri.parse('$apiUrlAuth/api/auth/forgot-password'),
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Forgot password token: " + data.toString());

        Fluttertoast.showToast(
          msg: 'Email đặt lại mật khẩu đã được gửi. Vui lòng kiểm tra hộp thư của bạn.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        resetTextField();

        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      } else {
        Fluttertoast.showToast(
          msg: 'Có lỗi xảy ra, vui lòng kiểm tra lại email của bạn',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Lỗi khi đặt lại mật khẩu: $e');
      Fluttertoast.showToast(
        msg: 'Có lỗi xảy ra, vui lòng thử lại',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _hideLoadingOverlay();
    }
  }

  // Hàm xử lý Keycloak token, lưu thông tin người dùng
  Future<void> _processKeycloakToken(BuildContext context, Map<String, dynamic> tokenData ) async {
    try {
      // Giải mã token
      String accessToken = tokenData['access_token'] ?? '';
      String refreshToken = tokenData['refresh_token'] ?? '';
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

      print("Decoded Token: " + decodedToken.toString());
      // Lấy thông tin từ token
      String userId = decodedToken['sub'] ?? '';
      String userName = decodedToken['name'] ?? decodedToken['preferred_username'] ?? '';
      String userEmail = decodedToken['email'] ?? '';
      List<String> roles = (decodedToken['realm_access']?['roles'] as List<dynamic>?)?.cast<String>() ?? [];

      // Lưu vào SharedPreferences
      await SPUtill.setValue(SPUtill.keyAccessToken, accessToken);
      await SPUtill.setValue(SPUtill.keyRefreshToken, refreshToken);
      await SPUtill.setValue(SPUtill.keyUserId, userId);
      await SPUtill.setValue(SPUtill.keyName, userName);
      await SPUtill.setValue(SPUtill.keyEmail, userEmail);
      await SPUtill.setValue(SPUtill.keyRoles, jsonEncode(roles));

      String isExistAccessToken = accessToken != '' ? "access_token exist" : 'no exist';
      String isExistRefreshToken = refreshToken != '' ? "refresh token exist" : 'no exist';

      print("-------------------------");
      print("Save Data : " + isExistAccessToken + ' ' + isExistRefreshToken + ' ' + userId + ' ' + userName + ' ' + userEmail + ' ' + roles.toString());
      print("-------------------------");
      print("check token : " + (await SPUtill.getValue(SPUtill.keyRefreshToken) ?? ''));
    } catch (e) {
      print('Lỗi khi giải mã Keycloak token: $e');
      Fluttertoast.showToast(
        msg: "Không thể lấy thông tin người dùng",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    _showLoadingOverlay(context);
    try {
      // Lấy refresh token từ SharedPreferences
      final refreshToken = await SPUtill.getValue(SPUtill.keyRefreshToken);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final response = await http.post(
          Uri.parse('$apiUrlAuth/api/auth/logout-keycloak'),
          headers: { 'Content-Type': 'application/json' },
          body: jsonEncode({'token': refreshToken}),
        );

        print("Logout response: ${response.statusCode}");

        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: 'Đăng xuất thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Đăng xuất thất bại: ${response.body}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }

      // Đăng xuất Google (nếu đăng nhập bằng Google)
      await _googleSignIn.signOut();

      // Xóa dữ liệu trong SharedPreferences
      await SPUtill.deleteKey(SPUtill.keyAccessToken);
      await SPUtill.deleteKey(SPUtill.keyRefreshToken);
      await SPUtill.deleteKey(SPUtill.keyUserId);
      await SPUtill.deleteKey(SPUtill.keyName);
      await SPUtill.deleteKey(SPUtill.keyEmail);
      await SPUtill.deleteKey(SPUtill.keyRoles);

      // Điều hướng về LoginScreen
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginProvider);
    } catch (e) {
      print('Lỗi đăng xuất: $e');
      Fluttertoast.showToast(
        msg: 'Có lỗi xảy ra khi đăng xuất',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _hideLoadingOverlay();
    }
  }

  void resetTextField() {
    emailTextController.clear();
    passwordTextController.clear();
    nameTextController.clear();
    notifyListeners();
  }
}