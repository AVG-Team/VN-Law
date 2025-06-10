import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/chat_message_model.dart';
import 'models/conversation_model.dart';

class ChatbotProvider extends ChangeNotifier {
  final List<ChatMessageModel> _messages = [];
  final List<ConversationModel> _conversations = [];
  final List<ConversationModel> _pinnedConversations = [];
  bool _isSidebarOpen = false;
  bool _isTyping = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _listKey = GlobalKey<AnimatedListState>();

  ChatbotProvider() {
    _loadFakeData();
  }

  List<ChatMessageModel> get messages => _messages;
  List<ConversationModel> get conversations => _conversations;
  List<ConversationModel> get pinnedConversations => _pinnedConversations;
  bool get isSidebarOpen => _isSidebarOpen;
  bool get isTyping => _isTyping;
  TextEditingController get emailController => _emailController;
  TextEditingController get messageController => _messageController;
  ScrollController get scrollController => _scrollController;
  GlobalKey<AnimatedListState> get listKey => _listKey;

  void _loadFakeData() {
    final now = DateTime.now();
    _conversations.addAll([
      ConversationModel(
        id: '1',
        title: 'Thông tin về luật dân sự mới nhất',
        lastMessageTime: now.subtract(const Duration(minutes: 30)),
        messages: [
          ChatMessageModel(
            text: 'Cho tôi biết thông tin về luật dân sự mới nhất',
            isUser: true,
            timestamp: now.subtract(const Duration(minutes: 35)),
          ),
          ChatMessageModel(
            text: 'Luật dân sự Việt Nam mới nhất là Bộ luật Dân sự 2015...',
            isUser: false,
            timestamp: now.subtract(const Duration(minutes: 30)),
          ),
        ],
      ),
      ConversationModel(
        id: '2',
        title: 'Quy định về hợp đồng lao động theo luật mới',
        lastMessageTime: now.subtract(const Duration(hours: 3)),
        messages: [
          ChatMessageModel(
            text: 'Quy định về hợp đồng lao động theo luật mới như thế nào?',
            isUser: true,
            timestamp: now.subtract(const Duration(hours: 3, minutes: 5)),
          ),
          ChatMessageModel(
            text: 'Theo Bộ luật Lao động 2019 (có hiệu lực từ 01/01/2021)...',
            isUser: false,
            timestamp: now.subtract(const Duration(hours: 3)),
          ),
        ],
      ),
      ConversationModel(
        id: '3',
        title: 'Quy định về thừa kế di sản không có di chúc',
        lastMessageTime: now.subtract(const Duration(days: 2)),
        messages: [
          ChatMessageModel(
            text: 'Quy định về thừa kế di sản không có di chúc theo pháp luật Việt Nam hiện nay như thế nào?',
            isUser: true,
            timestamp: now.subtract(const Duration(days: 2, hours: 1)),
          ),
          ChatMessageModel(
            text: 'Theo Bộ luật Dân sự 2015, thừa kế theo pháp luật...',
            isUser: false,
            timestamp: now.subtract(const Duration(days: 2)),
          ),
        ],
      ),
      ConversationModel(
        id: '4',
        title: 'Thủ tục xin cấp lại sổ đỏ bị mất',
        lastMessageTime: now.subtract(const Duration(days: 6)),
        messages: [
          ChatMessageModel(
            text: 'Tôi bị mất sổ đỏ, thủ tục xin cấp lại như thế nào?',
            isUser: true,
            timestamp: now.subtract(const Duration(days: 6, hours: 2)),
          ),
          ChatMessageModel(
            text: 'Để cấp lại sổ đỏ bị mất, bạn cần thực hiện các bước sau...',
            isUser: false,
            timestamp: now.subtract(const Duration(days: 6)),
          ),
        ],
      ),
      ConversationModel(
        id: '5',
        title: 'Mức phạt vượt đèn đỏ mới nhất',
        lastMessageTime: now.subtract(const Duration(days: 10)),
        messages: [
          ChatMessageModel(
            text: 'Mức phạt vượt đèn đỏ mới nhất là bao nhiêu?',
            isUser: true,
            timestamp: now.subtract(const Duration(days: 10, hours: 3)),
          ),
          ChatMessageModel(
            text: 'Theo Nghị định 100/2019/NĐ-CP và Nghị định 123/2021/NĐ-CP...',
            isUser: false,
            timestamp: now.subtract(const Duration(days: 10)),
          ),
        ],
      ),
    ]);
    _pinnedConversations.add(_conversations[0]);
    _pinnedConversations.add(_conversations[2]);
    notifyListeners();
  }

  void handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    final message = ChatMessageModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(message);
    _listKey.currentState?.insertItem(_messages.length - 1);
    notifyListeners();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 500), () {
      _isTyping = true;
      notifyListeners();
      _scrollToBottom();

      Future.delayed(const Duration(milliseconds: 1500), () {
        _isTyping = false;
        _simulateBotResponse(text);
      });
    });
  }

  void _simulateBotResponse(String userMessage) {
    String botResponse = '';
    if (userMessage.toLowerCase().contains('xin chào') ||
        userMessage.toLowerCase().contains('chào') ||
        userMessage.toLowerCase().contains('hello')) {
      botResponse = 'Xin chào! Tôi là VN-Law bot, tôi có thể giúp gì cho bạn về các vấn đề pháp luật Việt Nam?';
    } else {
      botResponse = 'Xin lỗi, tôi chưa có thông tin cụ thể về vấn đề này. Bạn có thể đặt câu hỏi khác hoặc làm rõ hơn vấn đề bạn đang quan tâm để tôi có thể giúp đỡ tốt hơn.';
    }

    final botMessage = ChatMessageModel(
      text: botResponse,
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(botMessage);
    _listKey.currentState?.insertItem(_messages.length - 1);

    if (_messages.length == 2) {
      final newConversation = ConversationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _messages.first.text.length > 150
            ? '${_messages.first.text.substring(0, 150)}...'
            : _messages.first.text,
        lastMessageTime: DateTime.now(),
        messages: List.from(_messages),
      );
      _conversations.insert(0, newConversation);
    }

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
    _messages.clear();
    _messages.addAll(conversation.messages);
    _isSidebarOpen = false;
    notifyListeners();
  }

  void resetState() {
    _messages.clear();
    _isTyping = false;
    _isSidebarOpen = false;
    print('State reset');
    notifyListeners();
  }

  String getConversationTimeGroup(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final lastWeek = today.subtract(const Duration(days: 7));

    final messageDay = DateTime(time.year, time.month, time.day);

    if (messageDay == today) {
      return 'Hôm nay';
    } else if (messageDay == yesterday) {
      return 'Hôm qua';
    } else if (messageDay.isAfter(lastWeek)) {
      return 'Trong 7 ngày';
    } else {
      return 'Cũ hơn';
    }
  }

  String getTimeDisplay(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(time.year, time.month, time.day);

    if (messageDay == today) {
      return DateFormat('HH:mm').format(time);
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(time);
    }
  }

  void disposeControllers() {
    _emailController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
  }
}