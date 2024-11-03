import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class ConversationsService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> createConversation(Conversation conversation) async {
    await databaseReference.child("conversations").child(conversation.conversationId).set(conversation.toJson());
  }

  Future<bool> addMessage(String conversationId, Message message) async {
    try {
      Map<String, dynamic> messageData = message.toJson();

      await databaseReference
          .child("conversations")
          .child(conversationId)
          .child("messages")
          .push()
          .set(messageData);

      String newEndTime = DateTime.now().toIso8601String();
      await databaseReference
          .child("conversations")
          .child(conversationId)
          .update({
        'endTime': newEndTime,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Conversation?> getFirstConversation(String userId) async {
    try {
      Query query = databaseReference
          .child("conversations")
          .orderByChild("userId")
          .equalTo(userId);

      DataSnapshot snapshot = await query.get();

      if (snapshot.exists) {
        List<Conversation> conversations = (snapshot.value as Map<dynamic, dynamic>)
            .entries
            .map((entry) {
          String conversationId = entry.key;
          return Conversation.fromMap(
              conversationId, entry.value as Map<dynamic, dynamic>);
        }).toList();
        conversations.sort((a, b) =>
            DateTime.parse(b.endTime).compareTo(DateTime.parse(a.endTime))); // Sắp xếp theo thời gian mới nhất
        return conversations.isNotEmpty ? conversations.first : null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting conversations: $e");
      }
    }
    return null;
  }

  Future<Conversation?> getConversation(String conversationId, String userId) async {
    try {
      Query query = databaseReference
          .child("conversations")
          .child(conversationId)
          .orderByChild("userId")
          .equalTo(userId);

      DataSnapshot snapshot = await query.get();

      if (snapshot.exists) {
        return Conversation.fromMap(
            conversationId, snapshot.value as Map<dynamic, dynamic>);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting conversation: $e");
      }
    }
    return null;
  }

  Future<List<Conversation>> getAllConversations(String userId) async {
    print("Get all conversations" + userId);
    List<Conversation> conversations = [];
    try {
      Query query = databaseReference
          .child("conversations")
          .orderByChild("userId")
          .equalTo(userId);

      DataSnapshot snapshot = await query.get();

      if (snapshot.exists) {
        for (var item in (snapshot.value as Map<dynamic, dynamic>).entries) {
          String key = item.key.toString();
          conversations.add(
              Conversation.fromMap(key, item.value as Map<dynamic, dynamic>));
        }
        conversations.sort((a, b) =>
            DateTime.parse(b.endTime).compareTo(DateTime.parse(a.endTime)));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting all conversations: $e");
      }
    }
    return conversations;
  }

  Future<void> updateConversation(Conversation conversation) async {
    await databaseReference.child("conversations").child(conversation.conversationId).update(conversation.toJson());
  }

  Future<void> deleteConversation(String conversationId) async {
    await databaseReference.child("conversations").child(conversationId).remove();
  }
}
