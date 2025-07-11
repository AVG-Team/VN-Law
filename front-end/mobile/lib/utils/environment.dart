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

  // Chat
  static String get apiAuthUrl => dotenv.env['API_AUTH_URL'] ?? '';

  // Auth
  static String get apiChatUrl => dotenv.env['API_CHAT_URL'] ?? '';

  // Law
  static String get apiLawUrl => dotenv.env['API_LAW_URL'] ?? '';

  // Forum
  static String get apiForumUrl => dotenv.env['API_FORUM_URL'] ?? '';

  // Keycloak
  static String get keycloakUrl => dotenv.env['keycloak_url'] ?? '';
  static String get keycloakId => dotenv.env['keycloak_id'] ?? '';
  static String get keycloakSecret => dotenv.env['keycloak_secret'] ?? '';

  // App
  static String get appName => dotenv.env['APP_NAME'] ?? '';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? '';

  // Firebase
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';

  // Other Services
  static String get googleMapsKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}