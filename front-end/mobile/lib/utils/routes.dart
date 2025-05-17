// lib/utils/routes.dart
import 'package:VNLAW/screens/auth/login/forgot_password_screen.dart';
import 'package:VNLAW/screens/auth/login/login_provider_screen.dart';
import 'package:VNLAW/screens/auth/login/register_screen.dart';
import 'package:flutter/material.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/home/profile_screen.dart';
import '../screens/splash_screen/splash_screen.dart';
import '../screens/auth/login/test_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String loginProvider = '/loginProvider';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String profile = '/profilAAAAe';
  static const String chatbot = '/chatbot';
  static const String test = '/test';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case loginProvider:
        return MaterialPageRoute(builder: (_) => const LoginProviderScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case chatbot:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case test:
        return MaterialPageRoute(builder: (_) => const TestScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginProviderScreen());
    }
  }
}