import 'package:flutter/material.dart';
import 'package:mobile/pages/Home/typewriter_text.dart';
import '../Welcome Page/WelcomeScreen.dart';


class BotMessage extends StatelessWidget {
  final String message;

  const BotMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/bot_avatar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: TypewriterTexts(message),
          ),
        ],
      ),
    );
  }
}