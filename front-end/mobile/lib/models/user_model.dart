import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? displayName;
  final String? email;
  final String? uid;
  final String? photoURL;
  final String? role;

  UserModel({
    this.displayName,
    this.email,
    this.uid,
    this.photoURL,
    this.role,
  });

  factory UserModel.fromFirebaseUser(User? user) {
    return UserModel(
      displayName: user?.displayName,
      email: user?.email,
      uid: user?.uid,
      photoURL: user?.photoURL,
      role: user?.email == "hung28122003cv@gmail.com" ? "Quản trị viên" : "Thành viên",
    );
  }

  static Future<UserModel> fromFirebaseUserWithRole(User? user) async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (!doc.exists) {
      throw Exception("Document does not exist for user: ${user?.uid}");
    }

    late String role; // Mặc định là "Thành viên"

    // Kiểm tra xem email có phải là của người dùng đặc biệt hay không
    if (user?.email == "hung28122003cv@gmail.com") {
      print(user?.email);
      role = "Quản trị viên";
    }

    return UserModel(
      displayName: user?.displayName,
      email: user?.email,
      uid: user?.uid,
      photoURL: user?.photoURL,
      role: role,
    );
  }
}
