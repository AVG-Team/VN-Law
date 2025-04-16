import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import 'widgets/chat_message.dart';
import 'widgets/chat_input.dart';
import 'models/chat_message_model.dart';
import 'models/conversation_model.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> with SingleTickerProviderStateMixin {
  final List<ChatMessageModel> _messages = [];
  final List<ConversationModel> _conversations = [];
  final List<ConversationModel> _pinnedConversations = [];
  bool _isSidebarOpen = false;
  late AnimationController _animationController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false; // Trạng thái bot đang nhập
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadFakeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadFakeData() {
    // Generate some fake conversations
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
            text: 'Luật dân sự Việt Nam mới nhất là Bộ luật Dân sự 2015, có hiệu lực từ ngày 01/01/2017. Đây là văn bản quy phạm pháp luật quan trọng điều chỉnh các quan hệ dân sự, quy định địa vị pháp lý, chuẩn mực pháp lý cho cách ứng xử của cá nhân, pháp nhân, chủ thể khác; quyền và nghĩa vụ của các chủ thể về nhân thân và tài sản.',
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
            text: 'Theo Bộ luật Lao động 2019 (có hiệu lực từ 01/01/2021), hợp đồng lao động được quy định như sau:\n\n1. Chỉ có 2 loại hợp đồng: Xác định thời hạn và không xác định thời hạn (bỏ hợp đồng dưới 12 tháng)\n2. Thời gian thử việc tối đa 180 ngày đối với công việc quản lý\n3. Người lao động có quyền đơn phương chấm dứt hợp đồng không cần lý do',
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
            text: 'Theo Bộ luật Dân sự 2015, thừa kế theo pháp luật (không có di chúc) được chia thành 3 hàng:\n\nHàng thừa kế thứ nhất: vợ, chồng, cha đẻ, mẹ đẻ, cha nuôi, mẹ nuôi, con đẻ, con nuôi của người chết.\n\nHàng thừa kế thứ hai: ông nội, bà nội, ông ngoại, bà ngoại, anh ruột, chị ruột, em ruột của người chết; cháu ruột của người chết mà người chết là ông nội, bà nội, ông ngoại, bà ngoại.\n\nHàng thừa kế thứ ba: cụ nội, cụ ngoại của người chết; bác ruột, chú ruột, cậu ruột, cô ruột, dì ruột của người chết; cháu ruột của người chết mà người chết là bác ruột, chú ruột, cậu ruột, cô ruột, dì ruột; chắt ruột của người chết mà người chết là cụ nội, cụ ngoại.',
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
            text: 'Để cấp lại sổ đỏ bị mất, bạn cần thực hiện các bước sau:\n\n1. Đăng tin báo mất trên phương tiện thông tin đại chúng\n2. Nộp đơn đề nghị cấp lại Giấy chứng nhận bị mất tại Văn phòng đăng ký đất đai nơi có đất\n3. Nộp kèm các giấy tờ: CMND/CCCD, giấy tờ chứng minh đã đăng tin báo mất, các giấy tờ về quyền sử dụng đất (nếu có)\n\nThời gian cấp lại: 30 ngày làm việc. Lệ phí: Khoảng 500.000 đồng (tùy địa phương).',
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
            text: 'Theo Nghị định 100/2019/NĐ-CP và Nghị định 123/2021/NĐ-CP, mức phạt khi vượt đèn đỏ như sau:\n\n- Người điều khiển xe máy vượt đèn đỏ: Phạt tiền từ 800.000 đồng đến 1.000.000 đồng, tước quyền sử dụng GPLX từ 1-3 tháng\n\n- Người điều khiển ô tô vượt đèn đỏ: Phạt tiền từ 3.000.000 đồng đến 5.000.000 đồng, tước quyền sử dụng GPLX từ 1-3 tháng.',
            isUser: false,
            timestamp: now.subtract(const Duration(days: 10)),
          ),
        ],
      ),
    ]);
    
    // Pin some conversations
    _pinnedConversations.add(_conversations[0]);
    _pinnedConversations.add(_conversations[2]);
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    final message = ChatMessageModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
    });

    // Scroll to bottom after message is sent
    _scrollToBottom();

    // Hiển thị trạng thái bot đang nhập
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
      }
      
      // Scroll to show the typing indicator
      _scrollToBottom();
      
      // Sau một khoảng thời gian, bot trả lời
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _isTyping = false;
          });
          _simulateBotResponse(text);
        }
      });
    });
  }

  void _simulateBotResponse(String userMessage) {
    // Simple responses based on keywords
    String botResponse = '';
    
    if (userMessage.toLowerCase().contains('xin chào') || 
        userMessage.toLowerCase().contains('chào') ||
        userMessage.toLowerCase().contains('hello')) {
      botResponse = 'Xin chào! Tôi là VN-Law bot, tôi có thể giúp gì cho bạn về các vấn đề pháp luật Việt Nam?';
    } else if (userMessage.toLowerCase().contains('luật dân sự')) {
      botResponse = 'Bộ luật Dân sự 2015 là văn bản pháp luật quan trọng điều chỉnh các quan hệ dân sự. Bạn quan tâm đến vấn đề cụ thể nào trong luật dân sự?';
    } else if (userMessage.toLowerCase().contains('luật lao động')) {
      botResponse = 'Bộ luật Lao động 2019 có hiệu lực từ ngày 01/01/2021, quy định về tiêu chuẩn lao động; quyền, nghĩa vụ, trách nhiệm của người lao động, người sử dụng lao động, tổ chức đại diện người lao động tại cơ sở, tổ chức đại diện người sử dụng lao động trong quan hệ lao động và các quan hệ khác liên quan trực tiếp đến quan hệ lao động.';
    } else if (userMessage.toLowerCase().contains('thừa kế')) {
      botResponse = 'Thừa kế ở Việt Nam được quy định trong Bộ luật Dân sự 2015, có hai hình thức là thừa kế theo di chúc và thừa kế theo pháp luật. Bạn muốn tìm hiểu về hình thức nào?';
    } else if (userMessage.toLowerCase().contains('hôn nhân')) {
      botResponse = 'Luật Hôn nhân và Gia đình 2014 quy định chế độ hôn nhân và gia đình, chuẩn mực pháp lý cho cách ứng xử của các thành viên trong gia đình; bảo vệ quyền, lợi ích hợp pháp của các thành viên trong gia đình, góp phần xây dựng, củng cố gia đình bền vững.';
    } else {
      botResponse = 'Xin lỗi, tôi chưa có thông tin cụ thể về vấn đề này. Bạn có thể đặt câu hỏi khác hoặc làm rõ hơn vấn đề bạn đang quan tâm để tôi có thể giúp đỡ tốt hơn.';
    }
    
    final botMessage = ChatMessageModel(
      text: botResponse,
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(botMessage);
    });

    // Tạo cuộc trò chuyện mới khi bắt đầu chat
    if (_messages.length == 2) {
      final newConversation = ConversationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _messages.first.text.length > 150 
            ? '${_messages.first.text.substring(0, 150)}...' 
            : _messages.first.text,
        lastMessageTime: DateTime.now(),
        messages: List.from(_messages),
      );
      
      setState(() {
        _conversations.insert(0, newConversation);
      });
    }

    // Scroll to bottom after receiving response
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
  
  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
    
    if (_isSidebarOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _closeSidebar() {
    if (_isSidebarOpen) {
      setState(() {
        _isSidebarOpen = false;
      });
      _animationController.reverse();
    }
  }

  void _pinConversation(ConversationModel conversation) {
    setState(() {
      if (_pinnedConversations.contains(conversation)) {
        _pinnedConversations.remove(conversation);
      } else {
        _pinnedConversations.add(conversation);
      }
    });
  }

  void _loadConversation(ConversationModel conversation) {
    setState(() {
      _messages.clear();
      _messages.addAll(conversation.messages);
      _isSidebarOpen = false;
    });
    _animationController.reverse();
  }

  void _shareConversation() {
    // In a real app, this would share the conversation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã chia sẻ cuộc trò chuyện này')),
    );
  }

  void _showContactAdminDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Liên hệ Admin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email của bạn',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Nội dung',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, this would send the email
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã gửi email đến admin')),
              );
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  String _getConversationTimeGroup(DateTime time) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSidebarOpen 
        ? null 
        : AppBar(
            title: const Text('VN Law Chatbot'),
            centerTitle: true,
            leading: IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animationController,
              ),
              onPressed: _toggleSidebar,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareConversation,
              ),
              IconButton(
                icon: const Icon(Icons.email),
                onPressed: _showContactAdminDialog,
              ),
            ],
          ),
      body: Stack(
        children: [
          // Main chat area
          Column(
            children: [
              // Messages area
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Hãy bắt đầu cuộc trò chuyện với VN Law Bot',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length + (_isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _messages.length) {
                            // Hiển thị indicator đang nhập
                            return Padding(
                              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue.shade600,
                                    child: const Icon(
                                      Icons.smart_toy,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Row(
                                      children: [
                                        _buildTypingDot(0),
                                        _buildTypingDot(1),
                                        _buildTypingDot(2),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          final message = _messages[index];
                          return ChatMessage(
                            message: message,
                            isFirst: index == 0 || 
                                _messages[index - 1].isUser != message.isUser,
                            isLast: index == _messages.length - 1 || 
                                _messages[index + 1].isUser != message.isUser,
                          );
                        },
                      ),
              ),
              
              // Input area
              ChatInput(onSendMessage: _handleSendMessage),
            ],
          ),
          
          // Overlay to detect outside clicks when sidebar is open
          if (_isSidebarOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeSidebar,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          
          // Sidebar
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isSidebarOpen ? MediaQuery.of(context).size.width * 0.8 : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: _isSidebarOpen ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ] : [],
              ),
              child: _isSidebarOpen ? SafeArea(
                child: Column(
                  children: [
                    // Header with close button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: _closeSidebar,
                          ),
                          const Text(
                            'Lịch sử đối thoại',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Pinned conversations
                    if (_pinnedConversations.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Đã ghim',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _pinnedConversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _pinnedConversations[index];
                          return ListTile(
                            leading: const Icon(Icons.chat_bubble_outline),
                            title: Text(
                              conversation.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              _getTimeDisplay(conversation.lastMessageTime),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.push_pin,
                                color: Colors.blue[600],
                              ),
                              onPressed: () => _pinConversation(conversation),
                            ),
                            onTap: () => _loadConversation(conversation),
                          );
                        },
                      ),
                      const Divider(height: 1),
                    ],
                    
                    // Regular conversations grouped by time
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _conversations[index];
                          final timeGroup = _getConversationTimeGroup(conversation.lastMessageTime);
                          
                          // Check if this is the first conversation of this time group
                          bool isFirstInGroup = index == 0 || 
                              _getConversationTimeGroup(_conversations[index - 1].lastMessageTime) != timeGroup;
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isFirstInGroup) 
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                                  child: Text(
                                    timeGroup,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ListTile(
                                leading: const Icon(Icons.chat_bubble_outline),
                                title: Text(
                                  conversation.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  _getTimeDisplay(conversation.lastMessageTime),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.push_pin,
                                    color: _pinnedConversations.contains(conversation) 
                                        ? Colors.blue[600] 
                                        : Colors.grey[400],
                                  ),
                                  onPressed: () => _pinConversation(conversation),
                                ),
                                onTap: () => _loadConversation(conversation),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ) : null,
            ),
          ),
        ],
      ),
    );
  }
  
  // Hiệu ứng đang nhập cho bot
  Widget _buildTypingDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 8,
      width: 8,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(5),
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.5, end: 1.0),
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 600),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
        ),
      ),
    );
  }
  
  // Hiển thị thời gian cho lịch sử chat
  String _getTimeDisplay(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(time.year, time.month, time.day);
    
    if (messageDay == today) {
      return DateFormat('HH:mm').format(time);
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(time);
    }
  }
} 