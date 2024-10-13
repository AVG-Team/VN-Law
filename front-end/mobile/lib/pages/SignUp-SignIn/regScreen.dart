import 'package:flutter/material.dart';
import 'typewriter_text.dart'; // Ensure the import path is correct
import 'loginScreen.dart'; // Import the login screen
class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _gmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidPhone(String text) {
    final validPhonePattern = RegExp(r'^(0[0-9]{9}|(\+84[0-9]{9}))$');
    return validPhonePattern.hasMatch(text);
  }

  bool _isValidGmail(String text) {
    return text.contains('@');
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
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: TypewriterText(
                text: 'Create Your\nAccount',
                duration: Duration(milliseconds: 150),
              ),
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
                    // Full Name TextField
                    TextField(
                      controller: _fullNameController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: _fullNameController.text.length > 4
                              ? const Color.fromARGB(255, 116, 192, 252)
                              : Colors.grey,
                        ),
                        label: const Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 116, 192, 252),
                          ),
                        ),
                      ),
                    ),
                    // Phone TextField with validation
                    TextField(
                      controller: _phoneController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.phone,
                          color: _isValidPhone(_phoneController.text)
                              ? const Color.fromARGB(255, 116, 192, 252)
                              : Colors.grey,
                        ),
                        label: const Text(
                          'Phone',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 116, 192, 252),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    // Gmail TextField with validation
                    TextField(
                      controller: _gmailController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.email,
                          color: _isValidGmail(_gmailController.text)
                              ? const Color.fromARGB(255, 116, 192, 252)
                              : Colors.grey,
                        ),
                        label: const Text(
                          'Gmail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 116, 192, 252),
                          ),
                        ),
                      ),
                    ),
                    // Password TextField with visibility toggle
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: _isPasswordVisible
                                ? const Color.fromARGB(255, 116, 192, 252)
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        label: const Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 116, 192, 252),
                          ),
                        ),
                      ),
                    ),
                    // Confirm Password TextField with visibility toggle
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: _isConfirmPasswordVisible
                                ? const Color.fromARGB(255, 116, 192, 252)
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        label: const Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 116, 192, 252),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 70),
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(255, 116, 192, 252),
                      ),
                      child: const Center(
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "You already have an account?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector( // Wrap the text with GestureDetector
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigate to LoginScreen
                              );
                            },
                            child: Text(
                              "Sign in",
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
}
