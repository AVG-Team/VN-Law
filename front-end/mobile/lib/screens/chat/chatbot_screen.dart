import 'package:VNLAW/screens/chat/widgets/chat_input.dart';
import 'package:VNLAW/screens/chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chatbot_provider.dart';
import 'models/conversation_model.dart';
import './widgets/typing.dart';


class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sidebarAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _sidebarAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatbotProvider>(context, listen: false).resetState();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatbotProvider>(context);
    if (provider.isSidebarOpen && _animationController.status != AnimationStatus.forward) {
      _animationController.forward();
    } else if (!provider.isSidebarOpen && _animationController.status != AnimationStatus.reverse) {
      _animationController.reverse();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(provider),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: provider.messages.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0), // Khoảng trắng 2 bên
                        child: Text(
                          'Hãy bắt đầu cuộc trò chuyện với VN Law Bot, Chúng tôi sẽ giúp bạn giải đáp các thắc mắc về pháp luật.',
                          textAlign: TextAlign.center, // Căn giữa nội dung
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : AnimatedList(
                  key: provider.listKey,
                  controller: provider.scrollController,
                  padding: const EdgeInsets.all(16),
                  initialItemCount: provider.messages.length + (provider.isTyping && provider.messages.isNotEmpty ? 1 : 0),
                  itemBuilder: (context, index, animation) {
                    print('Index: $index, Messages length: ${provider.messages.length}, isTyping: ${provider.isTyping}');
                    // Kiểm tra nếu index vượt quá độ dài danh sách tin nhắn, hiển thị TypingIndicator
                    if (index == provider.messages.length && provider.isTyping && provider.messages.isNotEmpty) {
                      return const TypingIndicator();
                    }
                    // Nếu index hợp lệ, lấy tin nhắn
                    if (index < provider.messages.length) {
                      final message = provider.messages[index];
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(animation),
                          child: ChatMessage(
                            message: message,
                            isFirst: index == 0 || (index > 0 && provider.messages[index - 1].isUser != message.isUser),
                            isLast: index == provider.messages.length - 1 || (index < provider.messages.length - 1 && provider.messages[index + 1].isUser != message.isUser),
                            isNewChat: provider.isNewChat,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink(); // Trả về widget rỗng nếu index không hợp lệ
                  },
                )
              ),
              ChatInput(onSendMessage: provider.handleSendMessage),
            ],
          ),
          if (provider.isSidebarOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  provider.closeSidebar();
                  _animationController.reverse();
                },
                behavior: HitTestBehavior.opaque,
                child: FadeTransition(
                  opacity: _sidebarAnimation,
                  child: Container(color: Colors.black.withOpacity(0.4)),
                ),
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: FadeTransition(
              opacity: _sidebarAnimation,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(_sidebarAnimation),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: provider.isSidebarOpen ? MediaQuery.of(context).size.width * 0.75 : 0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, spreadRadius: 2, offset: const Offset(2, 0)),
                    ],
                  ),
                  child: provider.isSidebarOpen
                      ? SafeArea(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade700, Colors.blue.shade500],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  provider.closeSidebar();
                                  _animationController.reverse();
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  'Lịch sử đối thoại',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (provider.pinnedConversations.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Đã ghim',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.grey[800], fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.pinnedConversations.length,
                            itemBuilder: (context, index) {
                              final conversation = provider.pinnedConversations[index];
                              return _buildConversationTile(context, provider, conversation, true);
                            },
                          ),
                          const Divider(height: 1, thickness: 1),
                        ],
                        Expanded(
                          child: provider.conversations.isEmpty
                                    ? const Center(
                                        child: Text(
                                            'Không có cuộc trò chuyện nào'))
                                    : ListView.builder(
                                        itemCount:
                                            provider.conversations.length,
                                        itemBuilder: (context, index) {
                                          final conversation =
                                              provider.conversations[index];
                                          // Không gọi updateLastMessageTime trong itemBuilder
                                          final timeGroup =
                                              provider.getConversationTimeGroup(
                                                  conversation
                                                          .lastMessageTime ??
                                                      DateTime.now());
                                          bool isFirstInGroup = index == 0 ||
                                              provider.getConversationTimeGroup(
                                                      provider
                                                              .conversations[
                                                                  index - 1]
                                                              .lastMessageTime ??
                                                          DateTime.now()) !=
                                                  timeGroup;
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (isFirstInGroup)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16.0,
                                                          top: 16.0,
                                                          bottom: 8.0),
                                                  child: Text(
                                                    timeGroup,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[800],
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              _buildConversationTile(
                                                  context,
                                                  provider,
                                                  conversation,
                                                  false),
                                            ],
                                          );
                                        }),
                              ),
                      ],
                    ),
                  )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(ChatbotProvider provider) {
    if (provider.isSidebarOpen) return null;
    if (provider.messages.isEmpty) {
      return AppBar(
        title: const Text('VN Law Chatbot', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _animationController, color: Colors.white),
          onPressed: () => provider.toggleSidebar(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.email, color: Colors.white),
            onPressed: () => _showContactAdminDialog(context, provider),
          ),
        ],
      );
    }
    return AppBar(
      title: const Text('VN Law Chatbot', style: TextStyle(fontWeight: FontWeight.w600)),
      centerTitle: true,
      backgroundColor: Colors.blue.shade700,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => provider.resetState(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.push_pin, color: Colors.white),
          onPressed: () {
            // TODO: Implement pin functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã chia sẻ cuộc trò chuyện này')),
          ),
        ),
      ],
    );
  }

  Widget _buildConversationTile(BuildContext context, ChatbotProvider provider, ConversationModel conversation, bool isPinned) {
    return InkWell(
      onTap: () => provider.loadConversation(conversation),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.chat_bubble_outline, color: Colors.blue.shade600, size: 20),
          ),
          title: Text(
            conversation.context,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          subtitle: Text(
            conversation.lastMessageTime != null
                ? provider.getTimeDisplay(conversation.lastMessageTime!)
                : 'Vừa xong',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.push_pin,
              color: provider.pinnedConversations.contains(conversation) ? Colors.blue.shade600 : Colors.grey[400],
              size: 20,
            ),
            onPressed: () => provider.pinConversation(conversation),
          ),
        ),
      ),
    );
  }

  void _showContactAdminDialog(BuildContext context, ChatbotProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Liên hệ Admin', style: TextStyle(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: provider.emailController,
              decoration: InputDecoration(
                labelText: 'Email của bạn',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: provider.messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Nội dung',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: Colors.blue.shade600,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi email đến admin')));
            },
            child: const Text('Gửi', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}