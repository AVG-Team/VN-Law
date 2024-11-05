import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/VBPL/vbplScreen.dart';

import 'Home/homeScreen.dart';
import 'LegalDocument/legalDocumentScreen.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<Dashboardscreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const VbplScreen(),
    const LegalDocumentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số được chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Hiển thị trang tương ứng
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 10 , right: 10 ), // Tạo khoảng cách dưới
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)), // Bo tròn các góc trên
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
          currentIndex: _selectedIndex, // Chỉ số mục hiện tại
          selectedItemColor: Colors.blue, // Màu sắc cho mục được chọn
          unselectedItemColor: Colors.grey, // Màu sắc cho mục không được chọn
          selectedFontSize: 13, // Kích thước font cho mục được chọn
          unselectedFontSize: 12, // Kích thước font cho mục không được chọn
          backgroundColor: Colors.transparent, // Đặt màu nền là trong suốt
          type: BottomNavigationBarType.fixed, // Loại thanh điều hướng
          onTap: _onItemTapped, // Xử lý sự kiện khi chọn mục
          elevation: 0, // Không có độ cao bóng cho BottomNavigationBar
        ),
      ),
    );
  }
}