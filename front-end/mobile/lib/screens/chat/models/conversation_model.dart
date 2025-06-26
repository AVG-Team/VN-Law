import 'chat_message_model.dart';

class ConversationModel {
  final String id;
  final String userId;
  final String context;
  final DateTime startedAt;
  final DateTime? endedAt;
  final List<ChatMessageModel> messages;
  DateTime? lastMessageTime;

  ConversationModel({
    required this.id,
    required this.userId,
    required this.context,
    required this.startedAt,
    this.endedAt,
    required this.messages,
    this.lastMessageTime,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['conversation_id'] as String,
      userId: json['user_id'] as String,
      context: json['context'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] != null ? DateTime.parse(json['ended_at'] as String) : null,
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((msg) => ChatMessageModel.fromJson(msg as Map<String, dynamic>))
          .toList(),
    );
  }
}