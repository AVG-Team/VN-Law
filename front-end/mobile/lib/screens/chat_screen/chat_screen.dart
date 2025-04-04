import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/message.dart';
import './widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String? conversationId;
  final String? initialMessage;
  const ChatScreen({super.key,this.conversationId,this.initialMessage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  final ConversationsService _conversationService = ConversationsService();
  final WebSocketChat _webSocketChat = WebSocketChat();
  bool _isWaitingForResponse = false;

  late StreamSubscription<DatabaseEvent> _messagesSubscription;
  late String currentConversationId;
  bool _isLoading = false;
  List<Message> messages = [];
  String _connectionStatus = 'disconnected';

  @override
  void initState() {
    super.initState();
    _setupConversation();
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    _webSocketChat.initializeWebSocket();

    _webSocketChat.connectionStatus.listen((status) {
      setState(() {
        _connectionStatus = status;
      });
    });

    _webSocketChat.messages.listen((botResponse) {
      if (botResponse.isNotEmpty) {
        _handleBotResponse(botResponse);
      }
    });
  }

  void _handleBotResponse(String botResponse) async {
    try {
      final botMessage = Message(
        id: const Uuid().v4(),
        senderId: 'bot',
        content: botResponse,
        timestamp: DateTime.now().toIso8601String(),
      );

      await _conversationService.addMessage(currentConversationId, botMessage);
    } catch (e) {
      _showError('Error handling bot response: $e');
    } finally {
      setState(() {
        _isWaitingForResponse = false;
      });
    }
  }

  Future<void> _setupConversation() async {
    setState(() => _isLoading = true);

    try {
      if (widget.conversationId != null) {
        // Load existing conversation
        currentConversationId = widget.conversationId!;

        String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
        var conversation = await _conversationService.getConversation(currentConversationId, userId);
        if (conversation != null) {
          setState(() {
            messages = conversation.messages;
          });
        }
      } else {
        // Create new conversation
        currentConversationId = const Uuid().v4();
        String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

        var newConversation = Conversation(
          conversationId: currentConversationId,
          userId: userId,
          messages: [],
          startTime: DateTime.now().toIso8601String(),
          endTime: DateTime.now().toIso8601String(),
        );

        await _conversationService.createConversation(newConversation);

        if (widget.initialMessage != null) {
          await sendMessage(widget.initialMessage!);
        }
      }

      // Setup real-time listener
      _setupMessageListener();
    } catch (e) {
      _showError('Error setting up conversation: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _setupMessageListener() {
    final messagesRef = FirebaseDatabase.instance
        .ref()
        .child('conversations')
        .child(currentConversationId)
        .child('messages');

    _messagesSubscription = messagesRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final messagesData = event.snapshot.value as Map<dynamic, dynamic>;
        List<Message> updatedMessages = [];

        messagesData.forEach((key, value) {
          updatedMessages.add(Message.fromMap(key, value as Map<dynamic, dynamic>));
        });

        setState(() {
          messages = updatedMessages..sort((a, b) =>
              DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)));
        });
      }
    });
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || _isWaitingForResponse) return;

    try {
      setState(() {
        _isWaitingForResponse = true;
      });

      final message = Message(
        id: const Uuid().v4(),
        senderId: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
        content: content,
        timestamp: DateTime.now().toIso8601String(),
      );

      await _conversationService.addMessage(currentConversationId, message);
      _messageController.clear();
      _webSocketChat.sendMessage(content);
    } catch (e) {
      _showError('Error sending message: $e');
      setState(() {
        _isWaitingForResponse = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _messagesSubscription.cancel();
    _messageController.dispose();
    _webSocketChat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Chatbot Pháp Luật VNLAW'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      drawer: const SideMenu(),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          ChatInput(onSendMessage: sendMessage, isWaitingForResponse: _isWaitingForResponse),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        return MessageBubble(
          message: message,
          isUser: message.senderId != 'bot',
        );
      },
    );
  }

  Widget buildUserMessage(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF007AFF),
          borderRadius: BorderRadius.circular(15),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ),
    );
  }
}
