import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../data/models/user_info.dart';
import '../../utils/app_const.dart';
import '../../utils/shared_preferences.dart';
import 'models/chat_message_model.dart';
import 'models/conversation_model.dart';

class ChatbotProvider extends ChangeNotifier {
  final List<ChatMessageModel> _messages = [];
  final List<ConversationModel> _conversations = [];
  final List<ConversationModel> _pinnedConversations = [];
  bool _isSidebarOpen = false;
  bool _isTyping = false;
  bool _isNewChat = false;
  String? _currentConversationId;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _listKey = GlobalKey<AnimatedListState>();
  final String _baseUrl = '${AppConst.apiChatUrl}/api/chat';

  ChatbotProvider() {
    fetchConversations();
  }

  List<ChatMessageModel> get messages => _messages;
  List<ConversationModel> get conversations => _conversations;
  List<ConversationModel> get pinnedConversations => _pinnedConversations;
  bool get isSidebarOpen => _isSidebarOpen;
  bool get isTyping => _isTyping;
  bool get isNewChat => _isNewChat;
  TextEditingController get emailController => _emailController;
  TextEditingController get messageController => _messageController;
  ScrollController get scrollController => _scrollController;
  GlobalKey<AnimatedListState> get listKey => _listKey;

  Future<void> fetchConversations() async {
    final url = Uri.parse('$_baseUrl/get-history');
    final token = await SPUtill.getValue(SPUtill.keyAccessToken);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final conversationsData = data['data']['conversations'] as List? ?? [];
      _conversations.clear();
      if (conversationsData.isNotEmpty) {
        _conversations.addAll(conversationsData.map((conv) {
          final conversation = ConversationModel.fromJson(conv);
          // Gán lastMessageTime từ endedAt nếu có, nếu không thì từ startedAt
          conversation.lastMessageTime = conversation.endedAt ?? conversation.startedAt;
          return conversation;
        }));
      }
      notifyListeners();
    } else {
      print('Error fetching conversations: ${response.statusCode}');
      _conversations.clear();
    }
  }

  Future<void> fetchMessages(String conversationId) async {
    final url = Uri.parse('$_baseUrl/get-messages?conversation_id=$conversationId');
    final token = await SPUtill.getValue(SPUtill.keyAccessToken);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final messagesData = data['data']['messages'] as List;
      _messages.clear();
      for (var msg in messagesData) {
        _messages.add(ChatMessageModel.fromJson(msg, isUser: true));
        _messages.add(ChatMessageModel.fromJson(msg, isUser: false));
      }
      notifyListeners();
    } else {
      // Xử lý lỗi
      print('Error fetching messages: ${response.statusCode}');
    }
  }

  Future<void> sendQuestion(String question) async {
    final url = Uri.parse('$_baseUrl/get-answer');
    final token = await SPUtill.getValue(SPUtill.keyAccessToken);
    final body = {
      'question': question,
      if (_currentConversationId != null) 'conversation_id': _currentConversationId,
    };
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final answerData = data['data'];
      final conversationId = answerData['conversation_id'];
      if (_currentConversationId == null) {
        _currentConversationId = conversationId;
        final userInfo = await UserInfo.initialize();
        final newConversation = ConversationModel(
          id: conversationId,
          userId: userInfo.userId,
          context: question,
          startedAt: DateTime.now(),
          messages: [],
        );
        _conversations.insert(0, newConversation);
        newConversation.lastMessageTime = DateTime.now();
      }
      final botMessage = ChatMessageModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: conversationId,
        question: null,
        content: answerData['context'],
        context: answerData['answer'],
        intent: answerData['intent'] ?? '',
        userId: 'bot',
        timestamp: DateTime.now(),
        isUser: false,
      );
      _messages.add(botMessage);
      _listKey.currentState?.insertItem(_messages.length - 1);

      // Cập nhật lastMessageTime cho cuộc trò chuyện
      final conversation = _conversations.firstWhere((c) => c.id == conversationId);
      conversation.lastMessageTime = DateTime.now();

      notifyListeners();
    } else {
      // Xử lý lỗi
      _messages.add(ChatMessageModel(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: _currentConversationId ?? '',
        question: null,
        content: 'Có lỗi xảy ra, vui lòng thử lại',
        context: '',
        intent: '',
        userId: 'bot',
        timestamp: DateTime.now(),
        isUser: false,
      ));
      notifyListeners();
    }
  }

  Future<void> handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final userInfo = await UserInfo.initialize();
    final userMessage = ChatMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: _currentConversationId ?? '',
      question: text,
      content: null,
      context: '',
      intent: '',
      userId: userInfo.userId,
      timestamp: DateTime.now(),
      isUser: true,
    );
    _messages.add(userMessage);
    print('Messages length: ${_messages.length}, isTyping: $_isTyping');
    _listKey.currentState?.insertItem(_messages.length - 1);
    _isNewChat = true;
    _isTyping = true;
    notifyListeners();
    _scrollToBottom();
    await sendQuestion(text);
    _isTyping = false;
    notifyListeners();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void toggleSidebar() {
    _isSidebarOpen = !_isSidebarOpen;
    notifyListeners();
  }

  void closeSidebar() {
    _isSidebarOpen = false;
    notifyListeners();
  }

  void pinConversation(ConversationModel conversation) {
    if (_pinnedConversations.contains(conversation)) {
      _pinnedConversations.remove(conversation);
    } else {
      _pinnedConversations.add(conversation);
    }
    notifyListeners();
  }

  void loadConversation(ConversationModel conversation) {
    _currentConversationId = conversation.id;
    _messages.clear();
    fetchMessages(conversation.id).then((_) {
      _isSidebarOpen = false;
      _isNewChat = false;
      notifyListeners();
    });
  }

  // void updateLastMessageTime(ConversationModel conversation) {
  //   if (conversation.lastMessageTime == null) {
  //     conversation.lastMessageTime = DateTime.now();
  //     notifyListeners();
  //   }
  // }

  void resetState() {
    _messages.clear();
    _isTyping = false;
    _isSidebarOpen = false;
    _isNewChat = false;
    _currentConversationId = null;
    notifyListeners();
  }

  String getConversationTimeGroup(DateTime? time) {
    if (time == null) return 'Vừa xong';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final lastWeek = today.subtract(const Duration(days: 7));
    final messageDay = DateTime(time.year, time.month, time.day);

    if (messageDay == today) return 'Hôm nay';
    if (messageDay == yesterday) return 'Hôm qua';
    if (messageDay.isAfter(lastWeek)) return 'Trong 7 ngày';
    return 'Cũ hơn';
  }

  String getTimeDisplay(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(time.year, time.month, time.day);

    if (messageDay == today) {
      return DateFormat('HH:mm').format(time);
    }
    return DateFormat('dd/MM/yyyy HH:mm').format(time);
  }

  void disposeControllers() {
    _emailController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
  }
}
