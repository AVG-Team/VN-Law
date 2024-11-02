// ignore_for_file: use_build_context_synchronously

import 'dart:async' show Future, Timer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Add Google Sign-In import
import 'package:mobile/pages/WelcomePage/reg_screen.dart';
import '../../services/google_sign_in_service.dart';
import '../Home/profile_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final GoogleSignInService _googleSignInService = GoogleSignInService(); // Service defined here
  final user = FirebaseAuth.instance.currentUser;
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignInService.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (googleUser != null) {
        // If login is successful, navigate to profile_screen.dart with Google name and email
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while waiting for the auth state
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasData) {
                  final user = userSnapshot.data;
                  return ProfileScreen(
                    name: user?.displayName ?? "No name",
                    email: user?.email ?? "No Email",
                    uid: user?.uid ?? "No UID",
                  );
                }
                return const Center(child: Text('No user logged in'));
              },
            ),
          ),
        );
      }

    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFFFFFF),
              Color(0xffD6EAF8),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Image(image: AssetImage('assets/logo.png')),
              ),
              const SizedBox(height: 60),
              const TypewriterText(text: 'Tri Thức Pháp Luật Việt Nam'), // Typewriter text widget
              const SizedBox(height: 100),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Container(
                  height: 55,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 116, 192, 252),
                  ),
                  child: const Center(
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegScreen()),
                  );
                },
                child: Container(
                  height: 55,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Center(
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100), // Increased spacing to move "Login with Social Media" down
              const Text(
                'Login with Google',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _handleGoogleSignIn(context),
                child: SvgPicture.asset(
                  'assets/social.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              const SizedBox(height: 40), // Adds space at the bottom if needed
            ],
          ),
        ),
      ),
    );
  }

}

class TypewriterText extends StatefulWidget {
  final String text;

  const TypewriterText({super.key, required this.text});

  @override
  TypewriterTextState createState() => TypewriterTextState(); // Use the public name
}

class TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  int _index = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_index];
          _index++;
        });
      } else {
        _index = 0;
        _displayedText = '';
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: const TextStyle(
        fontSize: 30,
        color: Colors.black,
      ),
    );
  }
}
