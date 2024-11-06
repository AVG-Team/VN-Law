import 'package:flutter/material.dart';
import 'package:mobile/pages/ChatScreen/homepage.dart';
import 'package:mobile/pages/Home/profile_screen.dart';
import 'package:mobile/pages/VBPL/vbpl_screen.dart';
import 'package:mobile/pages/Home/home_screen.dart';
import 'package:mobile/pages/LegalDocument/legal_document_screen.dart';
import 'package:mobile/pages/ChatScreen/chat_screen.dart'; // Import your ChatScreen page

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomeScreen(),
    const HomePageChatScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe to change pages
        children: _pages.map((page) {
          // Wrap each main page in a Navigator for independent inner navigation
          return Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Chatbot", // Label for ChatScreen
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 13,
          unselectedFontSize: 12,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 1) { // Chatbot screen index
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePageChatScreen()),
              );
            } else {
              _onItemTapped(index); // Navigate to other main pages
            }
          },
          elevation: 0,
        ),
      ),
    );
  }
}
