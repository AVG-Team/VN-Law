import 'package:flutter/material.dart';
import '../../services/websocket_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final WebSocketChat _webSocketChat = WebSocketChat();
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  String _connectionStatus = 'disconnected';

  @override
  void initState() {
    super.initState();
    _webSocketChat.initializeWebSocket();

    // Listen to connection status changes
    _webSocketChat.connectionStatus.listen((status) {
      setState(() {
        _connectionStatus = status;
      });
    });

    // Listen to incoming messages
    _webSocketChat.messages.listen((message) {
      setState(() {
        _messages.add('Received: $message');
      });
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final messageId = _webSocketChat.sendMessage(_messageController.text);
      setState(() {
        _messages.add('Sent: ${_messageController.text} (ID: $messageId)');
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _webSocketChat.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Chat Test'),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _connectionStatus == 'connected'
                          ? Colors.green
                          : _connectionStatus == 'error'
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_connectionStatus),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _messages[index],
                      style: TextStyle(
                        color: _messages[index].startsWith('Sent:')
                            ? Colors.blue
                            : Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
