import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add Scaffold key
  List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    });

    _controller.clear();

    String response = await _fetchResponseFromAPI(text);
    _addBotMessage(response);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the scaffold key
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
                    'assets/bot_avatar.png', // Path to your bot avatar image
                    height: 25, // Adjust the height as needed
                    width: 25,  // Adjust the width as needed
                  ),
                  title: Text('Pages',style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding cho toàn bộ phần
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa giữa logo và kính lúp
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0), // Thêm khoảng cách bên trái cho Text
                      child: Text(
                        'Tất cả Cuộc trò chuyện',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                        maxLines: 1, // Limit to one line
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0), // Thêm khoảng cách bên phải cho Icon
                      child: Icon(Icons.search), // Biểu tượng kính lúp bên phải
                    ), // Biểu tượng kính lúp bên phải
                  ],
                ),
              ),

              InkWell(
                onTap: () {
                  // Handle tap, e.g., navigate to chat details
                },
                child: ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
                    children: [
                      // Hình ảnh avatar của bot
                      Image.asset(
                        'assets/bot_avatar.png', // Đường dẫn đến avatar của bot
                        height: 20, // Điều chỉnh kích thước hình ảnh
                        width: 20,
                      ),
                      SizedBox(width: 10), // Khoảng cách giữa hình ảnh và tiêu đề
                      Text('Monica Bot'),
                    ],
                  ),
                  subtitle: Column( // Giữ Column cho subtitle
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello world in Flutter',
                        overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                        maxLines: 1, // Limit to one line
                      ),
                      Text(
                        'You: How old are you?',
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                        maxLines: 1, // Limit to one line
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('10:30 AM'),
                      SizedBox(height: 8),
                      Icon(Icons.more_horiz),
                    ],
                  ),
                ),
              ),


              InkWell(
                onTap: () {
                  // Handle tap, e.g., navigate to chat details
                },
                child: ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
                    children: [
                      // Hình ảnh avatar của bot
                      Image.asset(
                        'assets/bot_avatar.png', // Đường dẫn đến avatar của bot
                        height: 20, // Điều chỉnh kích thước hình ảnh
                        width: 20,
                      ),
                      SizedBox(width: 10), // Khoảng cách giữa hình ảnh và tiêu đề
                      Text('Monica Bot'),
                    ],
                  ),
                  subtitle: Column( // Giữ Column cho subtitle
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello world in Flutter',
                        overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                        maxLines: 1, // Limit to one line
                      ),
                      Text(
                        'You: How old are you?',
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                        maxLines: 1, // Limit to one line
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('10:30 AM'),
                      SizedBox(height: 8),
                      Icon(Icons.more_horiz),
                    ],
                  ),
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
              backgroundColor: Colors.white, // White background
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.black), // Black icons
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer(); // Open drawer via scaffold key
                },
              ),
              centerTitle: true, // Center title/logo
              title: Image.asset(
                'assets/logo.png', // Add your logo asset here
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
                    bottom: BorderSide(color: Colors.black, width: 2), // Black bottom border
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
            width: 40, // Set width of the avatar
            height: 40, // Set height of the avatar
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Make the image circular
              image: DecorationImage(
                image: AssetImage('assets/bot_avatar.png'),
                fit: BoxFit.cover, // Ensure the image fits the container
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
