import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? displayName;
  final String? email;
  final String? uid;
  final String? photoURL;
  final int role;

  UserModel({
    this.displayName,
    this.email,
    this.uid,
    this.photoURL,
    this.role = 0,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'uid': uid,
      'photoURL': photoURL,
      'role': role,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      displayName: data['displayName'],
      email: data['email'],
      uid: data['uid'],
      photoURL: data['photoURL'],
      role: data['role'] ?? 0,
    );
  }

  String get roleText => role == 1 ? "Admin" : "Member";
  bool get isAdmin => role == 1;
}
