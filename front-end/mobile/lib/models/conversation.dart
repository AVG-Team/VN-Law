import 'message.dart';

class Conversation {
  String conversationId;
  String userId;
  List<Message> messages;
  String startTime;
  String endTime;

  Conversation({
    required this.conversationId,
    required this.userId,
    required this.messages,
    String? startTime,
    String? endTime,
  }) : startTime = startTime ?? DateTime.now().toIso8601String(), endTime = endTime ?? DateTime.now().toIso8601String();

  factory Conversation.fromJson(Map<String, dynamic> json) {
    var messagesFromJson = json['messages'] as List;
    List<Message> messagesList = messagesFromJson.map((i) => Message.fromJson(i)).toList();

    return Conversation(
      conversationId: json['conversationId'],
      userId: json['userId'],
      messages: messagesList,
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  factory Conversation.fromMap(String key, Map<dynamic, dynamic> json) {
    List<Message> messagesList = [];

    // Xử lý messages là Map
    if (json['messages'] != null && json['messages'] is Map) {
      Map<dynamic, dynamic> messagesMap = json['messages'] as Map<dynamic, dynamic>;
      messagesList = messagesMap.entries.map((entry) {
        Map<dynamic, dynamic> messageData = entry.value as Map<dynamic, dynamic>;
        return Message(
          id: messageData['id'] ?? '',
          content: messageData['content'] ?? '',
          senderId: messageData['senderId'] ?? '',
          timestamp: messageData['timestamp'] ?? DateTime.now().toIso8601String(),
        );
      }).toList();
    }

    return Conversation(
      conversationId: key,
      userId: json['userId'] ?? '',
      messages: messagesList,
      startTime: json['startTime'] ?? DateTime.now().toIso8601String(),
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'userId': userId,
      'messages': messages.map((e) => e.toJson()).toList(),
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
