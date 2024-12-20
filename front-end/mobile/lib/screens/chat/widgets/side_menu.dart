import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/dashboard_screen.dart';
import 'package:mobile/utils/nav_utail.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/conversation.dart';
import '../../../models/menu_models.dart';
import '../../../services/conversations_service.dart';
import '../chat_screen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // late List<dynamic> _features = [];
  final ConversationsService _conversationsService = ConversationsService();
  List<Conversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      List<Conversation> conversations = await _conversationsService.getAllConversations(userId);
      if (kDebugMode) {
        print("Loaded conversations: ${conversations.length}");
      }
      for (var conv in conversations) {
        if (kDebugMode) {
          print("Conversation ${conv.conversationId}: ${conv.messages.length} messages");
        }
      }

      setState(() {
        _conversations = conversations..sort((a, b) =>
            DateTime.parse(b.endTime).compareTo(DateTime.parse(a.endTime)));
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error loading conversations: $e");
      }
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  List<MenuSection> _getMenuSections() {
    return [
      MenuSection(
        items: [
          MenuItem(
            icon: const Icon(Icons.home),
            title: 'Trang Chủ',
            onTap: () {
              NavUtil.navigateAndClearStack(context, const DashboardScreen());
            },
          ),
          MenuItem(
            icon: const Icon(Icons.explore_outlined),
            title: 'Khám Phá Trang Website Của Chúng Tôi',
            onTap: () async {
              // todo: Handle Change url
              Uri url = Uri.parse('https://flutter.dev');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
              // Handle Explore tap
            },
          ),
        ],
      ),
      MenuSection(
        title: 'Tất cả Cuộc trò chuyện',
        items: _conversations.map((conversation) {
          var sortedMessages = conversation.messages
            ..sort((b, a) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

          String title = sortedMessages.isNotEmpty
              ? sortedMessages[0].content
              : 'Không có tin nhắn';

          String? subtitle = sortedMessages.length > 1
              ? sortedMessages[1].content
              : null;

          String time = _getTimeAgo(DateTime.parse(conversation.startTime));

          return MenuItem(
            title: title,
            subtitle: subtitle,
            time: time,
            icon: PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Xóa'),
                    onTap: () async {
                      Navigator.pop(context);

                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: const Text('Bạn có chắc chắn muốn xóa cuộc trò chuyện này?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Hủy'),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('Xóa'),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        try {
                          await _conversationsService.deleteConversation(conversation.conversationId);
                          loadConversations();

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã xóa cuộc trò chuyện'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Lỗi khi xóa cuộc trò chuyện: $e'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(conversationId: conversation.conversationId),
                ),
              );
              // Xử lý khi tap vào conversation
            },
          );
        }).toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<MenuSection> sections = _getMenuSections();

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                'assets/logo.png',
                height: 50,
              ),
            ),
          ),
          ...sections.map((section) => _buildSection(section, context)),
        ],
      ),
    );
  }

  Widget _buildSection(MenuSection section, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 8),
            child: Text(
              section.title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ...section.items.map((item) => _buildMenuItem(item, context)),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item, BuildContext context) {
    return ListTile(
      leading: item.icon is PopupMenuButton ? null : item.icon,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.time != null)
            Text(
              item.time!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
      subtitle: item.subtitle != null ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (item.subtitle != null)
            Expanded(
              child: Text(
                item.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (item.icon is PopupMenuButton) item.icon!,
        ],
      ) : null,
      onTap: item.onTap,
    );
  }
}
