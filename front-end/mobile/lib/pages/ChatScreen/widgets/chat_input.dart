import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;

  const ChatInput({super.key, required this.onSendMessage});

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  bool _isTyping = false;
  final TextEditingController _controller = TextEditingController();

  void _onTextChanged(String text) {
    setState(() {
      _isTyping = text.isNotEmpty;
    });
  }

  void _sendMessage() {
    String message = _controller.text;
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _controller.clear();
      _onTextChanged('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onTextChanged,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Tin nhắn',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          if (_isTyping)
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF007AFF)),
              onPressed: _sendMessage,
            ),
        ],
      ),
    );
  }
}
