import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  String nodeKey;
  int pin;
  List<String> votedUserIds;

  Question({
    required this.question,
    required this.content,
    required this.idUser,
    required this.nameUser,
    required this.imageURL,
    required this.votes,
    required this.createdAt,
    required this.nodeKey,
    required this.pin,
    required this.votedUserIds,
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
      nodeKey: key,
      pin: json['pin'] as int? ?? 0,
      votedUserIds: ['votedUserIds'],
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