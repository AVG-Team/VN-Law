import 'package:VNLAW/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;  // Thêm thư viện http để gọi API

import 'auth_provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  // Hàm gọi API Flask
  Future<void> callFlaskApi(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/'),  // Dùng 10.0.2.2 nếu chạy trên emulator, hoặc IP của máy tính nếu chạy trên thiết bị thật
        headers: {
          'Authorization': 'Bearer $token',  // Gửi access token trong header
        },
      );

      if (response.statusCode == 200) {
        print('Phản hồi từ Flask: ${response.body}');
      } else {
        print('Lỗi khi gọi Flask API: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi gọi Flask API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Giả sử AuthProvider có phương thức để lấy access token
              var accessToken = await SPUtill.getValue(SPUtill.keyAccessToken);
              print(accessToken);

              if (accessToken != null && accessToken.isNotEmpty) {
                await callFlaskApi(accessToken);  // Gọi API Flask
              } else {
                print('Không tìm thấy access token. Vui lòng đăng nhập lại.');
              }

              // Nếu bạn muốn logout sau khi gọi API, hãy bỏ comment dòng dưới
              // await authProvider.logout(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Chào mừng đến Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}