import 'dart:async';

import 'package:flutter/material.dart';

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