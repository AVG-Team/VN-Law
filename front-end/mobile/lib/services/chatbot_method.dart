import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotMethods {
  static const String apiUrl = "https://your-backend-api.com/chat";

  static Future<String> fetchResponseFromAPI(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"message": text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        return "Đã có lỗi xảy ra. Vui lòng thử lại.";
      }
    } catch (e) {
      return "Không thể kết nối đến server.";
    }
  }

}