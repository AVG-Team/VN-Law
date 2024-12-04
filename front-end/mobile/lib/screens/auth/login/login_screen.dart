import 'package:flutter/material.dart';
// import 'package:vmoffice/api_service/connectivity/no_internet_screen.dart';
// import 'package:vmoffice/screens/auth/forget_password/forget_password.dart';
// import 'package:vmoffice/screens/auth/login/login_provider.dart';
// import 'package:vmoffice/utils/nav_utail.dart';
// import 'package:vmoffice/utils/res.dart';
import 'package:provider/provider.dart';

import '../../../api_service/connectivity/no_internet_screen.dart';
import '../../../custom_widgets/custom_button.dart';
import 'login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NoInternetScreen(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          key: context.watch<LoginProvider>().scaffoldKey,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Image.asset(
                        "assets/logo.png",
                        width: 250,
                      )
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  _buildTextField(
                    controller: context.watch<LoginProvider>().emailTextController,
                    label: 'Email',
                    suffixIcon: Icons.check,
                    isValid: context.watch<LoginProvider>().email != null,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Visibility(
                      visible: context.watch<LoginProvider>().email != null,
                      child: Text(
                        context.watch<LoginProvider>().email ?? "",
                        style: const TextStyle(color: Colors.red),
                      )),
                  Visibility(
                      visible: context.watch<LoginProvider>().error != null &&
                          context.watch<LoginProvider>().email == null &&
                          context.watch<LoginProvider>().password == null,
                      child: Text(
                        context.watch<LoginProvider>().error ?? "",
                        style: const TextStyle(color: Colors.red),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildPasswordField(
                    controller: context.watch<LoginProvider>().passwordTextController,
                    label: 'Password',
                    isVisible: _obscureText,
                    toggleVisibility: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Visibility(
                      visible: context.watch<LoginProvider>().password != null,
                      child: Text(
                        context.watch<LoginProvider>().password ?? "",
                        style: const TextStyle(color: Colors.red),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Đặt văn bản ở cuối dòng
                    children: [
                      Opacity(
                          opacity: 0.3,
                          child: InkWell(
                            onTap: () {
                              context.read<LoginProvider>().resetTextField();
                              // NavUtil.navigateScreen(context, const ForgetPassword());
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    title: "Login",
                    clickButton: () {
                      bool isValidate = context.read<LoginProvider>().isValidate();

                      if (isValidate) {
                        context.read<LoginProvider>().getUserInfo(context);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0),
                          Colors.grey.withOpacity(0.5),
                          Colors.grey.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      // Xử lý sự kiện khi nhấn
                      print("Google icon clicked");
                      // Thêm logic xử lý của bạn ở đây
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8), // Khoảng cách giữa icon và viền
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Bo tròn hoàn toàn
                        color: Colors.white, // Màu nền
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/google_icon.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData suffixIcon,
    required bool isValid,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color.fromARGB(255, 116, 192, 252), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            suffixIcon: Icon(
              suffixIcon,
              color: isValid ? const Color.fromARGB(255, 116, 192, 252) : Colors.grey,
            ),
            label: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 116, 192, 252),
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color.fromARGB(255, 116, 192, 252), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: isVisible,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
                color: isVisible ? Colors.grey : const Color.fromARGB(255, 116, 192, 252),
              ),
              onPressed: toggleVisibility,
            ),
            label: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 116, 192, 252),
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
