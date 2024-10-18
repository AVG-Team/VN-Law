import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  List<Conversation> conversations = []; // List to store conversations

  @override
  void initState() {
    super.initState();
    _loadConversations(); // Load conversations from local storage
    _addBotMessage("Chào mừng bạn đến với Chatbot!");
    _exampleUserMessage(); // Send example user message
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
      conversations.add(Conversation(userMessage: text, botMessage: "Đang chờ phản hồi...")); // Placeholder for bot response
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

  void _exampleUserMessage() {
    String exampleMessage = "Chào chatbot, cho tôi biết giờ mở cửa của cửa hàng bánh ngọt được không?";
    _sendMessage(exampleMessage);
  }

  Future<String> _fetchResponseFromAPI(String text) async {
    final String apiUrl = "https://your-backend-api.com/chat";
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

  // Load conversations from shared preferences
  Future<void> _loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? conversationsJson = prefs.getString('conversations');
    if (conversationsJson != null) {
      List<dynamic> jsonList = json.decode(conversationsJson);
      setState(() {
        conversations = jsonList.map((e) => Conversation.fromJson(e)).toList();
      });
    }
  }

  // Save conversations to shared preferences
  Future<void> _saveConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(conversations);
    await prefs.setString('conversations', jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  title: Text('Pages', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Tất cả Cuộc trò chuyện',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
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
                        // Handle tap, e.g., navigate to chat details
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
                            SizedBox(width: 10),
                            Text('Monica Bot'),
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
                              '${conversations[index].botMessage}',
                              style: TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(DateFormat.jm().format(DateTime.now())),
                            SizedBox(height: 8),
                            Icon(Icons.more_horiz),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
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
                icon: Icon(Icons.menu, color: Colors.black),
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
                  icon: Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return message.isUser
                      ? _buildUserMessage(context, message.text)
                      : _buildBotResponse(context, message.text);
                },
                physics: BouncingScrollPhysics(),
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
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF007AFF),
          borderRadius: BorderRadius.circular(15),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/bot_avatar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TypewriterText(text),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Color(0xFF2C2C2C),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Tin nhắn",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (value) => _sendMessage(value),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF007AFF)),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;

  const TypewriterText(this.text, {Key? key}) : super(key: key);

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTypewriterEffect();
  }

  void _startTypewriterEffect() {
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
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
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(12),
      child: Text(
        _displayedText,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

// Class to store individual conversation
class Conversation {
  String userMessage;
  String botMessage;

  Conversation({required this.userMessage, required this.botMessage});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userMessage: json['userMessage'],
      botMessage: json['botMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userMessage': userMessage,
      'botMessage': botMessage,
    };
  }
}
