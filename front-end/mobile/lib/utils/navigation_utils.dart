import 'package:flutter/material.dart';

class NavigationUtils {
  static void navigateToDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard', // Đường dẫn đến Dashboard_Screen
      (route) => false, // Xóa tất cả các màn hình trước đó
    );
  }

  static void navigateToDashboardWithData(BuildContext context, {Map<String, dynamic>? data}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
      (route) => false,
      arguments: data,
    );
  }
} 