import 'package:flutter/material.dart';
import 'package:mobile/screens/chat/home_page_chat_screen.dart';
import 'package:mobile/screens/home/home_screen.dart';
import 'package:mobile/screens/forum/forum_screen.dart';
import 'package:mobile/screens/profile_screen.dart';

import 'app_flow/navigation_bar/custom_bottom_navbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HomePageChatScreen(),
    const ForumScreenWrapper(),
    const ProfileScreen(),
  ];

  void _onTabChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _navigateToChatScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePageChatScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            _navigateToChatScreen();
          } else {
            _onTabChanged(index);
          }
        },
      ),
    );
  }
}