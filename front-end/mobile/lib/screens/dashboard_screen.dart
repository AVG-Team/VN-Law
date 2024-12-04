import 'package:flutter/material.dart';
import 'package:mobile/screens/home/profile_screen.dart';
// import 'package:mobile/screens/news/news_screen.dart';
import 'package:mobile/screens/screen_tmp.dart';

import 'app_flow/navigation_bar/custom_bottom_navbar.dart';
import 'home/home_screen.dart';
// import 'package:mobile/pages/ChatScreen/homepage.dart';
// import 'package:mobile/pages/Home/profile_screen.dart';
// import 'package:mobile/pages/Home/home_screen.dart';
// import 'package:mobile/pages/Forum/forum_screen.dart'; // Import your Forum screen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MyHomePage(title: "Chatbot"),
    const MyHomePage(title: "Forum"),
    const ProfileScreen(),
  ];

  void _onTabChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
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
        onTap: _onTabChanged,
      ),
    );
  }
}