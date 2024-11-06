import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/conversation.dart';

import 'package:mobile/pages/ChatScreen/widgets/chat_input.dart';
import 'package:mobile/pages/Home/profile_screen.dart';
import 'package:mobile/pages/WelcomePage/welcome_screen.dart';
import 'package:mobile/services/conversations_service.dart';
import 'package:provider/provider.dart';
import '../../services/auth_provider.dart';
import '../../services/json_processing.dart';
import 'chat_screen.dart';
import 'widgets/side_menu.dart';

class HomePageChatScreen extends StatefulWidget {
  const HomePageChatScreen({super.key});

  @override
  State<HomePageChatScreen> createState() => _HomePageChatScreenState();
}

class _HomePageChatScreenState extends State<HomePageChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Conversation? _conversationFirst;
  List<dynamic> _listConversationPopular = [];
  late final AuthProviderCustom _authProvider;

  @override
  void initState() {
    super.initState();
    loadUtilitiesMenu();
    _authProvider = Provider.of<AuthProviderCustom>(context, listen: false);
    checkAuth();
  }

  Future<void> checkAuth() async {
    await _authProvider.checkAuthState();
    if (_authProvider.userModel  == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      }
    }
  }

  Future<void> loadUtilitiesMenu() async {
    ConversationsService conversationsService = ConversationsService();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    Conversation? conversationFirst =
        await conversationsService.getFirstConversation(userId);
    List<dynamic> listConversationPopular =
        await loadData('assets/json/chat_conversation_popular.json');
    setState(() {
      _conversationFirst = conversationFirst;
      _listConversationPopular = listConversationPopular;
    });
  }

  void sendMessage(String? content) {
    if (content == null || content.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(initialMessage: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
            ),

          ),
        ],
      ),
      drawer: const SideMenu(),
      body: Column(
        children: [
          // Chat header
          if (_conversationFirst != null)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: const Icon(Icons.chat_bubble_outline,
                        color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    // Wrap với Expanded
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                conversationId:
                                    _conversationFirst?.conversationId),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _conversationFirst?.messages.isNotEmpty == true
                                ? _conversationFirst!.messages[1].content
                                : 'Không có nội dung',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          if (_conversationFirst!.messages.length > 1)
                            Text(
                              _conversationFirst!.messages[0].content,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Feature cards
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   child: Row(
          //     children: _features.map<Widget>((feature) {
          //       return _buildFeatureCard(
          //         feature['title'],
          //         feature['content'],
          //         Colors.blue,
          //       );
          //     }).toList(),
          //   ),
          // ),
          // List items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                ..._listConversationPopular.map((conversation) {
                  return _buildListItem(conversation['title']);
                }),
              ],
            ),
          ),
          // Bottom input bar
          ChatInput(onSendMessage: sendMessage, isWaitingForResponse: false),
          // Bottom navigation
        ],
      ),
    );
  }

  Widget _buildListItem(String title) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(initialMessage: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
