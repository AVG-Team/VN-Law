import 'package:flutter/material.dart';
import 'package:mobile/pages/ChatScreen/homepage.dart';
import 'package:mobile/pages/Home/profile_screen.dart';
import 'package:mobile/pages/WelcomePage/welcome_screen.dart';
import '../pages/VBPL/vbpl_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int currentIndex = 0; // Chỉ số mục hiện tại

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(0, Icons.home),
              _buildNavItem(1, Icons.my_library_books),
              _buildNavItem(2, Icons.smart_toy_outlined),
              _buildNavItem(3, Icons.forum),
              _buildNavItem(4, Icons.settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            currentIndex = index;
          });

          Widget screenWidget;

          switch (index) {
            case 1:
              screenWidget = const WelcomeScreen();
              break;
            case 2:
              screenWidget = const HomePageChatScreen();
              break;
            case 3:
              screenWidget = const ProfileScreen();
              break;
            case 4:
              screenWidget = const ProfileScreen();
              break;
            default:
              screenWidget = const WelcomeScreen();
          }

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => screenWidget),
                (Route<dynamic> route) => false,
          );
        },
        child: Icon(
          icon,
          color: isSelected ? Colors.red : Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}