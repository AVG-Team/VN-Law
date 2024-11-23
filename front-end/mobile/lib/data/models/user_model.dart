import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/domain/entities/user.dart';

class UserModel extends User{

  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.avatarUrl,
    required super.role,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['avatarUrl'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
    };
  }

  String get roleText => role == 1 ? "Admin" : "Member";
  bool get isAdmin => role == 1;
}
