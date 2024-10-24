import 'package:flutter/material.dart';
import '../../models/message.dart';
import 'bot_message.dart';
import 'user_message.dart';
class MessageList extends StatelessWidget {
  final List<Message> messages;

  const MessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return message.isUser
            ? UserMessage(message: message.text)
            : BotMessage(message: message.text);
      },
    );
  }
}