import 'package:flutter_dotenv/flutter_dotenv.dart';
class Env {
  static String get fileName =>
      const String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev') == 'prod'
          ? '.env.prod'
          : '.env.dev';

  static Future<void> init() async {
    await dotenv.load(fileName: fileName);
  }

  // API
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get apiNewsKey => dotenv.env['API_NEWS_KEY'] ?? '';

  // App
  static String get appName => dotenv.env['APP_NAME'] ?? '';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? '';

  // Firebase
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';

  // Other Services
  static String get googleMapsKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}