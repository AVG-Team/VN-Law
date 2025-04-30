import 'dart:convert';

import 'package:VNLAW/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../utils/environment.dart';
import '../../../utils/routes.dart';
import '../../../utils/shared_preferences.dart';
import 'keycloak_response.dart';
import 'auth_repository.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
  );

  // Đăng nhập bằng email và mật khẩu
  Future<void> loginWithEmail(BuildContext context) async {
    final email = emailTextController.text;
    final password = passwordTextController.text;
    try {
      final response = await http.post(
        Uri.parse('${Env.keycloakUrl}/realms/vnlaw/protocol/openid-connect/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'client_id': Env.keycloakId,
          'client_secret': Env.keycloakSecret,
          'username': email,
          'password': password,
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final keycloakToken = data['access_token'];
        await _processKeycloakToken(context, keycloakToken);
        Fluttertoast.showToast(
          msg: 'Đăng nhập thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        try {
          final errorData = jsonDecode(response.body);
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
    }
  }

  // Đăng nhập bằng Google
  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      // Gọi Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng hủy đăng nhập
        return;
      }

      // Lấy access token từ Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String accessToken = googleAuth.accessToken!;

      // Trao đổi token với Keycloak
      final KeycloakResponse<Map<String, dynamic>> apiResponse = await AuthRepository.exchangeToken('google', accessToken);

      if (apiResponse.result == true && apiResponse.data != null) {
        final keycloakToken = apiResponse.data!['access_token'];

        // Xử lý thông tin từ Keycloak token
        await _processKeycloakToken(context, keycloakToken);

        Fluttertoast.showToast(
          msg: "Đăng nhập thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: apiResponse.message ?? "Đăng nhập thất bại",
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
    }
  }

  // Register user
  Future<void> registerUser(BuildContext context) async {
    final email = emailTextController.text;
    final password = passwordTextController.text;
    final name = nameTextController.text;

    try {
      // Lấy token admin hợp lệ
      final adminToken = await AppConst.getAdminToken();

      // Bước 1: Tạo người dùng
      final createUserResponse = await http.post(
        Uri.parse('http://localhost:9090/admin/realms/vnlaw/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $adminToken',
        },
        body: jsonEncode({
          'email': email,
          'username': email,
          'firstName': name,
          'enabled': true,
          'emailVerified': false,
          'requiredActions': ['VERIFY_EMAIL'],
          'credentials': [
            {
              'type': 'password',
              'value': password,
              'temporary': false,
            }
          ],
        }),
      );

      print('Create user response: ${createUserResponse.statusCode} - ${createUserResponse.body}');
      print('Location header: ${createUserResponse.headers['location']}');

      if (createUserResponse.statusCode == 201) {
        // Bước 2: Lấy user ID từ header Location
        String? userId;
        final locationHeader = createUserResponse.headers['location'];
        if (locationHeader != null) {
          // Location header có dạng: http://localhost:9090/admin/realms/vnlaw/users/{userId}
          final uri = Uri.parse(locationHeader);
          userId = uri.pathSegments.last; // Lấy userId từ phần cuối của URL
          print('Extracted user ID: $userId');
        } else {
          // Nếu không có Location header, tìm user ID bằng API
          final findUserResponse = await http.get(
            Uri.parse('c'),
            headers: {
              'Authorization': 'Bearer $adminToken',
            },
          );

          print('Find user response: ${findUserResponse.statusCode} - ${findUserResponse.body}');

          if (findUserResponse.statusCode == 200) {
            final users = jsonDecode(findUserResponse.body) as List;
            if (users.isNotEmpty) {
              userId = users[0]['id'];
              print('Found user ID: $userId');
            }
          }
        }

        if (userId == null) {
          throw Exception('Không thể lấy user ID sau khi tạo người dùng');
        }

        // Bước 3: Gửi email xác minh
        final sendEmailResponse = await http.put(
          Uri.parse(
              'http://localhost:9090/admin/realms/vnlaw/users/$userId/execute-actions-email'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $adminToken',
          },
          body: jsonEncode(['VERIFY_EMAIL']),
        );

        print('Send email response: ${sendEmailResponse.statusCode} - ${sendEmailResponse.body}');

        if (sendEmailResponse.statusCode == 204) {
          Fluttertoast.showToast(
            msg: 'Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        } else {
          Fluttertoast.showToast(
            msg: 'Đăng ký thành công nhưng không thể gửi email xác minh: ${sendEmailResponse.body}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
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
    }
  }

  // Hàm reset mật khẩu mới
  Future<void> resetPassword(BuildContext context, email) async {
    try {
      print("email : " + email);
      // Lấy token admin hợp lệ
      final adminToken = await AppConst.getAdminToken();

      // Bước 1: Tìm user ID từ email
      final findUserResponse = await http.get(
        Uri.parse('http://localhost:9090/admin/realms/vnlaw/users?email=$email'),
        headers: {
          'Authorization': 'Bearer $adminToken',
        },
      );

      print('Find user response: ${findUserResponse.statusCode} - ${findUserResponse.body}');

      if (findUserResponse.statusCode == 200) {
        final users = jsonDecode(findUserResponse.body) as List;
        if (users.isEmpty) {
          Fluttertoast.showToast(
            msg: 'Email không tồn tại',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }

        final userId = users[0]['id'];
        print('Found user ID: $userId');

        // Bước 2: Gửi email reset mật khẩu
        final resetPasswordResponse = await http.put(
          Uri.parse(
              'http://localhost:9090/admin/realms/vnlaw/users/$userId/reset-password-email'),
          headers: {
            'Authorization': 'Bearer $adminToken',
          },
        );

        print('Reset password response: ${resetPasswordResponse.statusCode} - ${resetPasswordResponse.body}');

        if (resetPasswordResponse.statusCode == 204) {
          Fluttertoast.showToast(
            msg: 'Email đặt lại mật khẩu đã được gửi. Vui lòng kiểm tra hộp thư của bạn.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        } else {
          Fluttertoast.showToast(
            msg: 'Không thể gửi email đặt lại mật khẩu: ${resetPasswordResponse.body}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Lỗi khi tìm người dùng: ${findUserResponse.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Lỗi khi đặt lại mật khẩu: $e');
      Fluttertoast.showToast(
        msg: 'Có lỗi xảy ra, vui lòng thử lại: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Hàm xử lý Keycloak token, lưu thông tin người dùng
  Future<void> _processKeycloakToken(BuildContext context, String keycloakToken) async {
    try {
      // Giải mã token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(keycloakToken);

      // Lấy thông tin từ token
      String userId = decodedToken['sub'] ?? '';
      String userName = decodedToken['name'] ?? decodedToken['preferred_username'] ?? '';
      String userEmail = decodedToken['email'] ?? '';
      List<String> roles = (decodedToken['realm_access']?['roles'] as List<dynamic>?)?.cast<String>() ?? [];

      // Lưu vào SharedPreferences
      await SPUtill.setValue(SPUtill.keyAuthToken, keycloakToken);
      await SPUtill.setValue(SPUtill.keyUserId, userId);
      await SPUtill.setValue(SPUtill.keyName, userName);
      await SPUtill.setValue(SPUtill.keyEmail, userEmail);
      await SPUtill.setValue(SPUtill.keyRoles, jsonEncode(roles));

      print("Save Data : " + keycloakToken + ' ' + userId + ' ' + userName + ' ' + userEmail + ' ' + roles.toString());

      // Điều hướng đến dashboard
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
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
    try {
      // Lấy refresh token từ SharedPreferences
      final refreshToken = await SPUtill.getValue(SPUtill.keyRefreshToken);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final response = await http.post(
          Uri.parse('${Env.keycloakUrl}/realms/vnlaw/protocol/openid-connect/logout'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'client_id': Env.keycloakId,
            'client_secret': Env.keycloakSecret,
            'refresh_token': refreshToken,
          },
        );

        if (response.statusCode == 204) {
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
      await SPUtill.deleteKey(SPUtill.keyAuthToken);
      await SPUtill.deleteKey(SPUtill.keyRefreshToken);
      await SPUtill.deleteKey(SPUtill.keyUserId);
      await SPUtill.deleteKey(SPUtill.keyName);
      await SPUtill.deleteKey(SPUtill.keyEmail);
      await SPUtill.deleteKey(SPUtill.keyRoles);

      // Điều hướng về LoginScreen
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } catch (e) {
      print('Lỗi đăng xuất: $e');
      Fluttertoast.showToast(
        msg: 'Có lỗi xảy ra khi đăng xuất',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void resetTextField() {
    emailTextController.clear();
    passwordTextController.clear();
    nameTextController.clear();
    notifyListeners();
  }
}