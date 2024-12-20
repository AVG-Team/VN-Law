import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/screens/auth/welcome_provider.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/animation/type_writer/typewriter_text.dart';

class WelcomeScreenWrapper extends StatelessWidget {
  const WelcomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WelcomeProvider(context),
      child: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late WelcomeProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<WelcomeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WelcomeProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            key: provider.scaffoldKey,
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
                    const TypewriterText(text: 'Tri Thức Pháp Luật Việt Nam'),
                    const SizedBox(height: 100),
                    _buildButton(
                      label: 'SIGN IN',
                      onTap: context.watch<WelcomeProvider>().navigateToLogin,
                      isPrimary: true,
                    ),
                    const SizedBox(height: 20),
                    _buildButton(
                      label: 'SIGN UP',
                      onTap: () => context.watch<WelcomeProvider>().navigateToRegister,
                      isPrimary: false,
                    ),
                    const SizedBox(height: 100),
                    const Text(
                      'Login with Google',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: context.watch<WelcomeProvider>().handleGoogleSignIn,
                      child: SvgPicture.asset(
                        'assets/social.svg',
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isPrimary
              ? const Color.fromARGB(255, 116, 192, 252)
              : Colors.white,
          border: !isPrimary ? Border.all(color: Colors.white) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isPrimary ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}