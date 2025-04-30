class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:9001'; // For Android Emulator
  // static const String baseUrl = 'http://localhost:9001'; // For iOS Simulator

  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';
  static const String googleLoginEndpoint = '/api/auth/google-login';
  static const String refreshTokenEndpoint = '/api/auth/refresh-token';

  // Keycloak Direct URLs (optional for direct integration)
  static const String keycloakUrl = 'http://10.0.2.2:9090';
  static const String realm = 'mobile-app';
  static const String clientId = 'mobile-app-client';

  // Google OAuth
  static const String googleClientId = 'YOUR_GOOGLE_CLIENT_ID';
  static const String googleRedirectUri = 'com.yourapp.auth:/oauth2callback';
}