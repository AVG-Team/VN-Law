import 'package:VNLAW/utils/nav_util_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../utils/routes.dart';
import 'auth_provider.dart';

class LoginProviderScreen extends StatefulWidget {
  const LoginProviderScreen({super.key});

  @override
  State<LoginProviderScreen> createState() => _LoginProviderScreenState();
}

class _LoginProviderScreenState extends State<LoginProviderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    const int charCount = 16 + 13;
    const int charSpeedMs = 160;
    final int totalDurationMs = charCount * charSpeedMs;

    _controller = AnimationController(
      duration: Duration(milliseconds: totalDurationMs),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimationComplete = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/logo.png",
                width: 450,
              ),
            ),
            const SizedBox(height: 48),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                _isAnimationComplete
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pháp luật trong tay,',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent[400],
                      ),
                    ),
                    Text(
                      'chuẩn mỗi ngày',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent[400],
                      ),
                    ),
                  ],
                )
                    : AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Pháp luật trong tay',
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent[400],
                      ),
                      speed: const Duration(milliseconds: 110),
                    ),
                    TypewriterAnimatedText(
                      'chuẩn mỗi ngày',
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent[400],
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  isRepeatingAnimation: false,
                  pause: const Duration(milliseconds: 0),
                  onFinished: () {
                    print('Hiệu ứng AnimatedTextKit hoàn tất');
                  },
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    double textWidth = MediaQuery.of(context).size.width - 24;
                    double ballPosition = _animation.value * textWidth;
                    double topPosition = _animation.value < 0.5 ? 0 : 30;

                    return Positioned(
                      left: ballPosition,
                      top: topPosition,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    // Gọi loginWithGoogle và chờ kết quả
                    final bool loginSuccess = await authProvider.loginWithGoogle(context);
                    if (context.mounted && loginSuccess) {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          settings: const RouteSettings(name: AppRoutes.dashboard),
                          pageBuilder: (context, animation, secondaryAnimation) => AppRoutes.getRoute(AppRoutes.dashboard),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.decelerate;

                            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 800),
                        ),
                      );
                    }
                  } catch (e) {
                    print('Login failed: $e');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đăng nhập thất bại: $e')),
                      );
                    }
                  }
                },
                icon: Image.asset(
                  "assets/google_icon.png",
                  width: 24,
                  height: 24,
                ),
                label: const Text("Tiếp tục với Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton.icon(
                onPressed: () {
                  NavUtilAnimation.navigateScreen(context, AppRoutes.login);
                },
                icon: const Icon(Icons.email),
                label: const Text("Tiếp tục với Email"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}