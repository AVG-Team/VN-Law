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
  bool _isAnimationComplete = false; // Trạng thái để kiểm soát hiển thị văn bản tĩnh

  @override
  void initState() {
    super.initState();
    // Tính toán thời gian dựa trên số ký tự và tốc độ của AnimatedTextKit
    const int charCount = 16 + 13; // "Pháp luật trong tay" (16 ký tự) + "chuẩn mỗi ngày" (13 ký tự, tính cả khoảng cách)
    const int charSpeedMs = 160; // Tốc độ mỗi ký tự (milliseconds)
    final int totalDurationMs = charCount * charSpeedMs; // Tổng thời gian hiệu ứng

    _controller = AnimationController(
      duration: Duration(milliseconds: totalDurationMs), // Đồng bộ với AnimatedTextKit
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Khi hiệu ứng hoàn tất, cập nhật trạng thái để hiển thị văn bản tĩnh
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
    final buttonWidth = MediaQuery.of(context).size.width * 0.8; // Đặt độ rộng là 80% chiều rộng màn hình

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phần ảnh đầu trang
            Center(
              child: Image.asset(
                "assets/logo.png", // Thay bằng đường dẫn logo của bạn
                width: 450,
              ),
            ),
            const SizedBox(height: 48),
            // Phần chữ châm ngôn với hiệu ứng
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Hiển thị văn bản tĩnh sau khi hiệu ứng hoàn tất
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
                    // Phần 1: "Pháp luật trong tay"
                    TypewriterAnimatedText(
                      'Pháp luật trong tay',
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent[400],
                      ),
                      speed: const Duration(milliseconds: 110), // Tốc độ chữ xuất hiện
                    ),
                    // Phần 2: "chuẩn mỗi ngày" (xuống dòng)
                    TypewriterAnimatedText(
                      'chuẩn mỗi ngày',
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent[400],
                      ),
                      speed: const Duration(milliseconds: 100), // Tốc độ chữ xuất hiện
                    ),
                  ],
                  isRepeatingAnimation: false,
                  pause: const Duration(milliseconds: 0), // Không tạm dừng giữa các phần
                  onFinished: () {
                    print('Hiệu ứng AnimatedTextKit hoàn tất');
                  },
                ),
                // Quả bóng di chuyển
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    // Tính toán vị trí của quả bóng dựa trên chiều dài văn bản và số dòng
                    double textWidth = MediaQuery.of(context).size.width - 24;
                    double ballPosition = _animation.value * textWidth;

                    // Điều chỉnh vị trí quả bóng theo dòng
                    double topPosition = _animation.value < 0.5 ? 0 : 30; // 30 là khoảng cách giữa 2 dòng (ước lượng)

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
            // Nút đăng nhập Google
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await authProvider.loginWithGoogle(context);
                },
                icon: Image.asset(
                  "assets/google_icon.png", // Đảm bảo có logo Google trong assets
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
            // Nút đăng nhập Email
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.login);
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