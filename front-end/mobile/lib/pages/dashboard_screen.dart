import 'package:flutter/material.dart';
import 'package:mobile/pages/ChatScreen/homepage.dart';
import 'package:mobile/pages/Home/profile_screen.dart';
import 'package:mobile/pages/Home/home_screen.dart';
import 'package:mobile/pages/Forum/forum_screen.dart'; // Import your Forum screen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<Widget> _pages = [
    const HomeScreen(),
    const HomePageChatScreen(),
    const ForumScreen(), // Add the Forum screen here
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) { // Chatbot screen index
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomePageChatScreen(),
        ),
      );
      return;
    }

    if (index == _selectedIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      setState(() {
        _pages[index] = index == 0
            ? const HomeScreen()
            : index == 2
            ? const ForumScreen()
            : const ProfileScreen();
      });
    }
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
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(_pages.length, (index) {
          return Navigator(
            key: _navigatorKeys[index],
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => _pages[index],
            ),
          );
        }),
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
              label: "Chatbot",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: "Forum", // Add the Forum tab here
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
          onTap: _onItemTapped,
          elevation: 0,
        ),
      ),
    );
  }
}