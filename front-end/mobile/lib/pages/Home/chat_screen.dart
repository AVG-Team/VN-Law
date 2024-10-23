import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../models/conversation.dart';
import '../../models/message.dart';
import 'message_list.dart';
import 'typewriter_text.dart';
import '../../services/conversation_controller.dart';
import '../../services/chatbot_method.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Message> messages = [];
  final TextEditingController point = TextEditingController();
  List<Conversation> conversations = [];
  late final ConversationController conversation_controller;
  Future<void> initializeController() async {
    await conversation_controller.init(conversations);
  }

  @override
  void initState() {
    super.initState();
    addBotMessage("Chào mừng bạn đến với Chatbot!");
    conversation_controller = ConversationController(setState: setState);
  }

  void addBotMessage(String text) {
    setState(() {
      messages.add(Message(text: text, isUser: false));
    });
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      messages.add(Message(text: text, isUser: true));
      conversations.add(Conversation(
          userMessage: text,
          botMessage: "Đang chờ phản hồi..."));
    });

    point.clear();

    String response = await ChatBotMethods.fetchResponseFromAPI(text);
    addBotMessage(response);

    setState(() {
      conversations.last.botMessage = response;
      conversation_controller.saveConversations(conversations);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 50,
                  ),
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/bot_avatar.png',
                    height: 25,
                    width: 25,
                  ),
                  title: const Text('Pages',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Tất cả Cuộc trò chuyện',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Navigate to conversation detail
                      },
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/bot_avatar.png',
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text('Monica Bot'),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversations[index].userMessage,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              conversations[index].botMessage,
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_horiz, color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'modify',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Modify',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'share',
                                child: Row(
                                  children: [
                                    Icon(Icons.share, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Share',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ];
                          },
                          onSelected: (String value) {
                            if (value == 'delete') {
                                conversation_controller.deleteConversation(index,conversations);
                            } else if (value == 'modify') {

                            } else if (value == 'share') {

                            }
                          },
                          elevation: 4,
                          offset: const Offset(0, 40),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      endDrawer:  Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/user_avatar.png'),
                ),
              ),
              const Text(
                'John Doe',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'johndoe@example.com',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.palette, color: Colors.black),
                title: const Text('Chế độ màu sắc'),
                onTap: () {
                  // Logic for changing color mode
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.black),
                title: const Text('Ngôn ngữ'),
                onTap: () {
                  // Logic for changing language
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          AppBar(
            title: const Text('Chat Screen'),
            actions: [
              IconButton(
                icon: const Icon(Icons .account_circle),
                onPressed: () {
                  _scaffoldKey.currentState
                      ?.openEndDrawer(); // Open right drawer
                },
              ),
            ],
          ),
          Expanded(
            child: MessageList(messages: messages),
          ),
          _buildInputField(context),
        ],
      ),
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

  Widget buildBotResponse(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/bot_avatar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TypewriterTexts(text),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF007AFF)),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: point,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Tin nhắn",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (value) => sendMessage(value),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF007AFF)),
            onPressed: () => sendMessage(point.text),
          ),
        ],
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'history_chat.dart';
import 'package:uuid/uuid.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  List<Conversation> conversations = []; // List to store conversations

  @override
  void initState() {
    super.initState();
    _loadConversations("0"); // Load conversations from local storage
    _addBotMessage("Chào mừng bạn đến với Chatbot!");
  }

  void _addBotMessage(String text) {
    setState(() {
      messages.add(Message(text: text, isUser: false));
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      messages.add(Message(text: text, isUser: true)); // Add user message
      // Save the conversation
      conversations.add(Conversation(
          id: const Uuid().v4(),
          userMessage: text,
          botMessage: "Đang chờ phản hồi...")); // Placeholder for bot response
    });

    _controller.clear();

    String response = await _fetchResponseFromAPI(text);
    _addBotMessage(response);

    // Update the last conversation with the bot response
    setState(() {
      conversations.last.botMessage = response; // Update bot message
      _saveConversations(); // Save to local storage
    });
  }

  Future<String> _fetchResponseFromAPI(String text) async {
    const String apiUrl = "https://your-backend-api.com/chat";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"message": text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        return "Đã có lỗi xảy ra. Vui lòng thử lại.";
      }
    } catch (e) {
      return "Không thể kết nối đến server.";
    }
  }

// Load conversations from shared preferences based on conversationId
  Future<void> _loadConversations(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? conversationsJson = prefs.getString('conversations');
    if (conversationsJson != null) {
      List<dynamic> jsonList = json.decode(conversationsJson);
      // Lọc ra cuộc hội thoại theo ID
      conversations = jsonList
          .map((e) => Conversation.fromJson(e))
          .where((conversation) => conversation.id == conversationId) // Giả sử có trường id trong Conversation
          .toList();
      setState(() {
        // Cập nhật danh sách các cuộc hội thoại
      });
    }
  }


  // Save conversations to shared preferences
  Future<void> _saveConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(conversations);
    await prefs.setString('conversations', jsonString);
  }

  // Method to delete a conversation
  void _deleteConversation(int index) {
    setState(() {
      conversations.removeAt(index); // Remove the selected conversation
    });
    _saveConversations(); // Save changes to local storage
  }

  void _modifyConversation(int index) {
    // Logic to modify the conversation
    // For example, show a dialog with a TextField to edit the message
  }

  void _shareConversation(int index) {
    // Logic to share the conversation
    // You can use the Share plugin to share the content
    // Example: Share.share(conversations[index].userMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // Left Drawer (unchanged)
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Header section with centered logo
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.asset(
                    'assets/logo.png', // Your logo here
                    height: 50,
                  ),
                ),
              ),
              // Main section of menu with ripple animation
              InkWell(
                onTap: () {
                  // Handle tap, e.g., navigate to chat details
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/bot_avatar.png',
                    height: 25,
                    width: 25,
                  ),
                  title: const Text('Pages',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Tất cả Cuộc trò chuyện',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              // Display the list of conversations
              Expanded(
                child: ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationDetailScreen(
                              userMessage: conversations[index].userMessage,
                              botMessage: conversations[index].botMessage,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/bot_avatar.png',
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text('Monica Bot'),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversations[index].userMessage,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              conversations[index].botMessage,
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon:
                              const Icon(Icons.more_horiz, color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'modify',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Modify',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'share',
                                child: Row(
                                  children: [
                                    Icon(Icons.share, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Share',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ];
                          },
                          onSelected: (String value) {
                            if (value == 'delete') {
                              _deleteConversation(index);
                            } else if (value == 'modify') {
                              _modifyConversation(index);
                            } else if (value == 'share') {
                              _shareConversation(index);
                            }
                          },
                          // Use this to change how the menu opens
                          elevation: 4,
                          offset: const Offset(0, 40), // Adjusts position
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),

      // Right Drawer (added)
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Profile Section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('assets/user_avatar.png'), // User avatar image
                ),
              ),
              const Text(
                'John Doe', // User's name
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'johndoe@example.com', // User's email
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.palette, color: Colors.black),
                title: const Text('Chế độ màu sắc'), // Color mode
                onTap: () {
                  // Logic for changing color mode
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.black),
                title: const Text('Ngôn ngữ'), // Language
                onTap: () {
                  // Logic for changing language
                },
              ),
            ],
          ),
        ),
      ),

      // Main Body (unchanged)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFFFFFF),
              Color(0xffD6EAF8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              centerTitle: true,
              title: Image.asset(
                'assets/logo.png',
                height: 50,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle,
                      color: Colors.black), // Changed to user icon
                  onPressed: () {
                    _scaffoldKey.currentState
                        ?.openEndDrawer(); // Open right drawer
                  },
                ),
              ],
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return message.isUser
                      ? _buildUserMessage(context, message.text)
                      : _buildBotResponse(context, message.text);
                },
                physics: const BouncingScrollPhysics(),
              ),
            ),
            _buildInputField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMessage(BuildContext context, String text) {
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

  Widget _buildBotResponse(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/bot_avatar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TypewriterText(text),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0), // Adjust the radius as needed
          topRight: Radius.circular(16.0), // Adjust the radius as needed
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon:
                const Icon(Icons.add_circle_outline, color: Color(0xFF007AFF)),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Tin nhắn",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (value) => _sendMessage(value),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF007AFF)),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;

  const TypewriterText(this.text, {super.key});

  @override
  TypewriterTextState createState() => TypewriterTextState();
}

class TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTypewriterEffect();
  }

  void _startTypewriterEffect() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      child: Text(
        _displayedText,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}



*/
