import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    required this.onPressed,
    required this.text,
    super.key, required Color textColor,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        top: 20,
        bottom: 10,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Button color
            foregroundColor: Colors.white, // Text color
            elevation: 0, // Optional: remove button shadow if it's affecting visibility
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}