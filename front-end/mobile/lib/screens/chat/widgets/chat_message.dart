import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_message_model.dart';

class ChatMessage extends StatefulWidget {
  final ChatMessageModel message;
  final bool isFirst;
  final bool isLast;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.message.isUser 
          ? const Offset(1, 0) 
          : const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Chỉ hiển thị giờ cho tin nhắn hôm nay
    String timeText = '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(
      widget.message.timestamp.year, 
      widget.message.timestamp.month, 
      widget.message.timestamp.day
    );
    
    if (messageDay == today) {
      timeText = DateFormat('HH:mm').format(widget.message.timestamp);
    } else {
      timeText = DateFormat('dd/MM HH:mm').format(widget.message.timestamp);
    }

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.isFirst ? 8.0 : 2.0,
            bottom: widget.isLast ? 8.0 : 2.0,
          ),
          child: Row(
            mainAxisAlignment: widget.message.isUser 
                ? MainAxisAlignment.end 
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.message.isUser) ...[
                CircleAvatar(
                  backgroundColor: Colors.blue.shade600,
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: widget.message.isUser 
                      ? CrossAxisAlignment.end 
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.message.isUser 
                            ? Colors.blue.shade600 
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16).copyWith(
                          bottomRight: widget.message.isUser 
                              ? const Radius.circular(2) 
                              : null,
                          bottomLeft: !widget.message.isUser 
                              ? const Radius.circular(2) 
                              : null,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.message.text,
                        style: TextStyle(
                          color: widget.message.isUser 
                              ? Colors.white 
                              : Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4, 
                        vertical: 2,
                      ),
                      child: Text(
                        timeText,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.message.isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    Icons.person,
                    color: Colors.blue.shade600,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 