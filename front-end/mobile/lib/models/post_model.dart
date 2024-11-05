import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/models/replies_model.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/services/auth_provider.dart';
import 'package:provider/provider.dart';

class Question {
  String question;
  String content;
  final String idUser;
  final String nameUser;
  final String imageURL;
  int votes;
  String createdAt;
  List<Reply> replies;
  String nodeKey;
  int pin;

  Question({
    required this.question,
    required this.content,
    required this.idUser,
    required this.nameUser,
    required this.imageURL,
    required this.votes,
    required this.createdAt,
    required this.replies,
    required this.nodeKey,
    required this.pin,
  });

  factory Question.fromJson(Map<String, dynamic> json, String key) {
    return Question(
      question: json['question'] as String? ?? '', // Corrected key
      content: json['content'] as String? ?? '',
      idUser: json['idUser'] as String? ?? '',
      nameUser: json['nameUser'] as String? ?? '',
      imageURL: json['imageURL'] as String? ?? '',
      votes: json['votes'] as int? ?? 0,
      createdAt: json['createdAt'] as String? ?? "0",
      replies: [], // Assuming Reply has a fromJson method
      nodeKey: key,
      pin: json['pin'] as int? ?? 0,
    );
  }

  Future<UserModel?> getUserModelIdFromUserId() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(idUser)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        return UserModel.fromFirestore(userDoc);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting user model from user ID: $e");
      }
    }
    return null;
  }
}
List<Question> questions = [
  Question(
    idUser: "1",
    nameUser: "Mark",
    imageURL: "assets/author1.jpg",
    question: 'C ## In A Nutshell',
    content: "Lorem  I've been using C# for a whole decade now, if you guys know how to break the boring feeling of letting to tell everyone of what happened in the day",
    createdAt: "2024-11-05 09:45:16.674839",
    votes: 100,
    replies: [], // Sample data; should be populated in a real scenario
    nodeKey: "", // Thêm nodeKey vào dữ liệu mẫu
    pin: 0,
  ),
  // Add other sample questions...
];