import 'chat_message_model.dart';

class ConversationModel {
  final String id;
  final String title;
  final DateTime lastMessageTime;
  final List<ChatMessageModel> messages;

  ConversationModel({
    required this.id,
    required this.title,
    required this.lastMessageTime,
    required this.messages,
  });
} 