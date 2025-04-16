// lib/utils/routes.dart
import 'package:VNLAW/screens/home/profile_screen.dart';
import 'package:flutter/material.dart';

import '../screens/auth/login/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String chatbot = '/chatbot';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      case chatbot:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );
      default:
      // Tuyến đường không xác định sẽ chuyển về màn hình đăng nhập Todo: Notfound Screen
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
    }
  }
}