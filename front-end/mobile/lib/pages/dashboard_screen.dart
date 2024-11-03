import 'package:flutter/material.dart';
import 'package:mobile/pages/VBPL/vbplScreen.dart';

import 'Home/home_screen.dart';
import 'LegalDocument/legalDocumentScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const VbplScreen(),
    const LegalDocumentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 10 , right: 10 ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
          boxShadow: [
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
              icon: Icon(Icons.search_outlined),
              label: 'Tra cứu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner),
              label: 'Văn bản pháp luật',
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