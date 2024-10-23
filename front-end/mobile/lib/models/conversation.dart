class Conversation {
  String userMessage;
  String botMessage;

  Conversation({required this.userMessage, required this.botMessage});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userMessage: json['userMessage'],
      botMessage: json['botMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userMessage': userMessage,
      'botMessage': botMessage,
    };
  }
}