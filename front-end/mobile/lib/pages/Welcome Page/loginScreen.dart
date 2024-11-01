import 'package:flutter/material.dart';
import 'package:mobile/pages/Welcome%20Page/regScreen.dart';
import 'typewriter_text.dart'; // Ensure the import path is correct
import '../../services/google_sign_in_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Color _iconColor = Colors.grey; // Default icon color
  bool _obscureText = true; // Toggle for password visibility

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _iconColor =
            _emailController.text.contains('@') ? Colors.blue : Colors.grey;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffFFFFFF),
                Color(0xffD6EAF8),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 22),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Color.fromARGB(255, 116, 192, 252),
                      size: 30), // Increased size for visibility
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                const SizedBox(
                    width: 8), // Add some spacing between the icon and text
                const TypewriterText(
                  text: 'Back',
                  duration: Duration(milliseconds: 150),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Email TextField
                    _buildTextField(
                      controller: _emailController,
                      label: 'Gmail',
                      suffixIcon: Icons.check,
                      isValid: _iconColor == Colors.blue,
                    ),
                    // Password TextField
                    _buildPasswordField(
                      controller: _passwordController,
                      label: 'Password',
                      isVisible: _obscureText,
                      toggleVisibility: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xff281537),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    // Sign In Button
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(255, 116, 192, 252),
                      ),
                      child: const Center(
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 150),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegScreen()),
                              );
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: const Color.fromARGB(255, 116, 192, 252), width: 2),
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            suffixIcon: Icon(
              suffixIcon,
              color: isValid
                  ? const Color.fromARGB(255, 116, 192, 252)
                  : Colors.grey,
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
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: const Color.fromARGB(255, 116, 192, 252), width: 2),
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
                color: isVisible
                    ? Colors.grey
                    : const Color.fromARGB(255, 116, 192, 252),
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
