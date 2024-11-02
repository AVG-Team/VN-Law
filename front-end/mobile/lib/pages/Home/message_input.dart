import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) sendMessage;

  const MessageInput({required this.controller, required this.sendMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF007AFF)),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Tin nhắn",
                border: InputBorder.none,
              ),
              onSubmitted: sendMessage,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF007AFF)),
            onPressed: () => sendMessage(controller.text),
          ),
        ],
      ),
    );
  }
}