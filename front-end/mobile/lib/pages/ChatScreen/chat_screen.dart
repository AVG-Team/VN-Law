import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../services/conversations_service.dart';
import '../../services/chatbot_service.dart';
import './widgets/message_bubble.dart';
import 'package:mobile/pages/ChatScreen/widgets/side_menu.dart';
import 'package:mobile/pages/ChatScreen/widgets/chat_input.dart';

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
  final ChatBotService _chatBotService = ChatBotService();

  late StreamSubscription<DatabaseEvent> _messagesSubscription;
  late String currentConversationId;
  bool _isLoading = false;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _setupConversation();
  }

  Future<void> _setupConversation() async {
    setState(() => _isLoading = true);

    try {
      if (widget.conversationId != null) {
        // Load existing conversation
        currentConversationId = widget.conversationId!;
        var conversation = await _conversationService.getConversation(currentConversationId);
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
    if (content.trim().isEmpty) return;

    try {
      final message = Message(
        id: const Uuid().v4(),
        senderId: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
        content: content,
        timestamp: DateTime.now().toIso8601String(),
      );

      await _conversationService.addMessage(currentConversationId, message);
      _messageController.clear();

      // Get chatbot response
      final botResponse = await _chatBotService.getBotResponse(content);

      if (botResponse != null) {
        final botMessage = Message(
          id: const Uuid().v4(),
          senderId: 'bot',
          content: botResponse,
          timestamp: DateTime.now().toIso8601String(),
        );

        await _conversationService.addMessage(currentConversationId, botMessage);
      }
    } catch (e) {
      _showError('Error sending message: $e');
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Chat Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Nút quay lại
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
      ),
      drawer: const SideMenu(),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          ChatInput(onSendMessage: sendMessage),
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
