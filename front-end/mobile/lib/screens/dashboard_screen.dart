import 'package:VNLAW/screens/forums/forum_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_flow/navigation_bar/custom_bottom_navbar.dart';
import 'chat/chatbot_provider.dart';
import 'home/home_screen.dart';
import 'home/profile_screen.dart';
import 'chat/chatbot_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatbotScreen(),
    const ForumScreen(),
    // const TestScreen(),
    const ProfileScreen(),
  ];

  void _onTabChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
        if (index == 1) {
          Provider.of<ChatbotProvider>(context, listen: false).resetState();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatbotProvider = Provider.of<ChatbotProvider>(context);
    final isChatbotScreen = _currentIndex == 1;
    final showNavbar = !isChatbotScreen ||
        (isChatbotScreen && chatbotProvider.messages.isEmpty && !chatbotProvider.isSidebarOpen);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: showNavbar
          ? CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      )
          : null,
    );
  }
}