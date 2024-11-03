import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? displayName;
  final String? email;
  final String? uid;
  final String? photoURL;

  UserModel({
    this.displayName,
    this.email,
    this.uid,
    this.photoURL,
  });

  factory UserModel.fromFirebaseUser(User? user) {
    return UserModel(
      displayName: user?.displayName,
      email: user?.email,
      uid: user?.uid,
      photoURL: user?.photoURL,
    );
  }
}