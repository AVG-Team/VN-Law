import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/message.dart';
import '../../models/conversation.dart';

class ConversationController {
  final List<Message> messages = [];
  final TextEditingController textController = TextEditingController();
  final Function(VoidCallback) setState;
  static const String conversationsKey = 'conversations';
  ConversationController({required this.setState});

  Future<void> init(conversations) async {
    await loadConversations("0",conversations);
  }

  Future<void> loadConversations(String conversationId,conversations) async {
    conversations.clear();
    final allConversations = await getConversations();
    conversations.addAll(
      // ignore: unrelated_type_equality_checks
      allConversations.where((conv) => conv == conversationId),
    );
  }
  Future<List<Conversation>> getConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? conversationsJson = prefs.getString(conversationsKey);
    if (conversationsJson != null) {
      List<dynamic> jsonList = json.decode(conversationsJson);
      return jsonList.map((e) => Conversation.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveConversations(conversations) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(conversations);
    await prefs.setString('conversations', jsonString);
  }
  // Method to delete a conversation
  Future<void> deleteConversation(int index,conversations) async{

    if (index >= 0 && index < conversations.length) {
      setState(() {
        conversations.removeAt(index);
      });
      saveConversations(conversations); // Save after deletion
    }
  }
  Future<void> modifyConversation(int index) async {
    // Logic to modify the conversation
    // For example, show a dialog with a TextField to edit the message
  }

  Future<void> shareConversation(int index) async {
    // Logic to share the conversation
    // You can use the Share plugin to share the content
    // Example: Share.share(conversations[index].userMessage);
  }
}


