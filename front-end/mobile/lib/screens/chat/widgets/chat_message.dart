import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../chatbot_provider.dart';
import '../models/chat_message_model.dart';

// ChatMessage Widget
class ChatMessage extends StatefulWidget {
  final ChatMessageModel message;
  final bool isFirst;
  final bool isLast;
  final bool isNewChat;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isFirst,
    required this.isLast,
    required this.isNewChat,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String _displayText = '';
  int _currentCharIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    if (!widget.message.isUser && widget.isNewChat) {
      _startTypingEffect();
    } else {
      _displayText = (widget.message.isUser ? widget.message.question! : widget.message.content)!;
    }
  }

  void _startTypingEffect() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _typeNextCharacter();
    });
  }

  void _typeNextCharacter() {
    final text = widget.message.content!;
    if (_currentCharIndex < text.length) {
      setState(() {
        _displayText = text.substring(0, _currentCharIndex + 1);
        _currentCharIndex++;
      });
      Future.delayed(const Duration(milliseconds: 35), _typeNextCharacter);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timeText = '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(widget.message.timestamp.year, widget.message.timestamp.month, widget.message.timestamp.day);

    if (messageDay == today) {
      timeText = DateFormat('HH:mm').format(widget.message.timestamp);
    } else {
      timeText = DateFormat('dd/MM HH:mm').format(widget.message.timestamp);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.isFirst ? 12.0 : 4.0,
            bottom: widget.isLast ? 12.0 : 4.0,
            left: 12.0,
            right: 12.0,
          ),
          child: Row(
            mainAxisAlignment: widget.message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.message.isUser) ...[
                CircleAvatar(
                  backgroundColor: Colors.blue.shade600,
                  radius: 18,
                  child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: widget.message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: widget.message.isUser
                            ? LinearGradient(
                          colors: [Colors.blue.shade600, Colors.blue.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : LinearGradient(
                          colors: [Colors.grey.shade100, Colors.grey.shade200],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20).copyWith(
                          bottomRight: widget.message.isUser ? const Radius.circular(4) : null,
                          bottomLeft: !widget.message.isUser ? const Radius.circular(4) : null,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayText,
                            style: TextStyle(
                              color: widget.message.isUser ? Colors.white : Colors.black87,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                          if (!widget.message.isUser) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PopupMenuButton<String>(
                                  icon: Consumer<ChatbotProvider>(
                                    builder: (context, provider, child) {
                                      if (provider.isSummarizing) {
                                        return SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
                                          ),
                                        );
                                      }
                                      return Icon(
                                        Icons.more_vert,
                                        color: Colors.grey.shade600,
                                        size: 20,
                                      );
                                    },
                                  ),
                                  onSelected: (value) {
                                    if (value == 'summarize') {
                                      final provider = Provider.of<ChatbotProvider>(context, listen: false);
                                      provider.summarizeMessage(widget.message, context);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem<String>(
                                      value: 'summarize',
                                      child: Consumer<ChatbotProvider>(
                                        builder: (context, provider, child) {
                                          return Row(
                                            children: [
                                              if (provider.isSummarizing)
                                                SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
                                                  ),
                                                )
                                              else
                                                const Icon(Icons.summarize, size: 18),
                                              const SizedBox(width: 8),
                                              Text(provider.isSummarizing ? 'Đang tóm tắt...' : 'Tóm tắt'),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        timeText,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.message.isUser) ...[
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  radius: 18,
                  child: Icon(Icons.person, color: Colors.blue.shade600, size: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
