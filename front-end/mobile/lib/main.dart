import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/pages/Forum/forum_screen.dart';
void main() {
  // Set status bar color to transparent
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Legal Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const CourtroomSplashScreen(),
    );
  }
}

class CourtroomSplashScreen extends StatefulWidget {
  const CourtroomSplashScreen({super.key});

  @override
  State<CourtroomSplashScreen> createState() => _CourtroomSplashScreenState();
}

class _CourtroomSplashScreenState extends State<CourtroomSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Define logo scaling effect
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Define fade-in effect
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start animation and navigate to ChatScreen after completion
    _controller.forward().whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ForumScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _logoScaleAnimation,
            child: Image.asset('assets/logo.png', width: 300, height: 300),
          ),
        ),
      ),
    );
  }
}
