class ChatMessageModel {
  final String id;
  final String conversationId;
  final String? question;
  final String? content;
  final String context;
  final String intent;
  final String userId;
  final DateTime timestamp;
  final bool isUser;

  ChatMessageModel({
    required this.id,
    required this.conversationId,
    this.question,
    this.content,
    required this.context,
    required this.intent,
    required this.userId,
    required this.timestamp,
    required this.isUser,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, {bool isUser = false}) {
    return ChatMessageModel(
      id: json['message_id'].toString(),
      conversationId: json['conversation_id'] as String,
      question: isUser ? json['question'] as String : null,
      content: !isUser ? json['content'] as String : null,
      context: json['context'] as String,
      intent: json['intent'] as String? ?? '',
      userId: json['user_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUser: isUser,
    );
  }
}