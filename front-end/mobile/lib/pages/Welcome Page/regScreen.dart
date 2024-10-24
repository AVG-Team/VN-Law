import 'package:flutter/material.dart';
import 'typewriter_text.dart'; // Ensure the import path is correct

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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 22),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 116, 192, 252), size: 30), // Increased size for visibility
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                const SizedBox(width: 8), // Add some spacing between the icon and text
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
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
                border: Border.all(color: const Color.fromARGB(255, 116, 192, 252), width: 0.5), // Add outline
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Full Name TextField
                    _buildTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      suffixIcon: Icons.check,
                      isValid: _fullNameController.text.length > 4,
                    ),
                    // Phone TextField with validation
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      suffixIcon: Icons.phone,
                      isValid: _isValidPhone(_phoneController.text),
                      keyboardType: TextInputType.phone,
                    ),
                    // Gmail TextField with validation
                    _buildTextField(
                      controller: _gmailController,
                      label: 'Gmail',
                      suffixIcon: Icons.email,
                      isValid: _isValidGmail(_gmailController.text),
                    ),
                    // Password TextField with visibility toggle
                    _buildPasswordField(
                      controller: _passwordController,
                      label: 'Password',
                      isVisible: _isPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    // Confirm Password TextField with visibility toggle
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      isVisible: _isConfirmPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    // Sign Up Button
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
                    const SizedBox(height: 150),
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
          borderRadius: BorderRadius.circular(30),
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
          obscureText: !isVisible,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: isVisible ? const Color.fromARGB(255, 116, 192, 252) : Colors.grey,
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
