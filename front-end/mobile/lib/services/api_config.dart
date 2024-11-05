class ApiConfig {
  static const String baseUrl = 'http://localhost:9000';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer YOUR_JWT_TOKEN',
  };
}
