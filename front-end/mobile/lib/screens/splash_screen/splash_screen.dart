import 'package:VNLAW/screens/splash_screen/splash_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  double _opacity = 0.0;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    // First animation - fade in logo
    _timer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // // Todo : Show Text if want
    // Second animation - show text
    // Timer(const Duration(milliseconds: 1500), () {
    //   setState(() {
    //     _showText = true;
    //   });
    // });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashProvider(context),
      child: Consumer<SplashProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with fade animation
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 1000),
                    child: Image.asset(
                      "assets/logo.png",
                      height: 200,
                    ),
                  ),
                  // Todo : Show Text if want
                  // const SizedBox(height: 30),
                  // // Text with fade animation
                  // AnimatedOpacity(
                  //   opacity: _showText ? 1.0 : 0.0,
                  //   duration: const Duration(milliseconds: 800),
                  //   child: const Column(
                  //     children: [
                  //       CircularProgressIndicator(
                  //         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  //       ),
                  //       SizedBox(height: 20),
                  //       Text(
                  //         "VN Law",
                  //         style: TextStyle(
                  //           fontSize: 24,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.blue,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 12),
                  //       Text(
                  //         "Biết quyền lợi của bạn, trao quyền cho tương lai",
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w400,
                  //           color: Colors.blue,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
