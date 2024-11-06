import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthProviderCustom with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  Future<void> checkAuthState() async {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await _loadUserData(firebaseUser);
    }
    notifyListeners();
  }

  Future<void> _loadUserData(User firebaseUser) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        _userModel = UserModel.fromFirestore(userDoc);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading user data: $e");
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Kiểm tra xem user đã tồn tại trong Firestore chưa
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // Tạo new user trong Firestore
          final newUser = UserModel(
            displayName: user.displayName,
            email: user.email,
            uid: user.uid,
            photoURL: user.photoURL,
            role: 0, // Default role
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(newUser.toMap());

          _userModel = newUser;
        } else {
          _userModel = UserModel.fromFirestore(userDoc);
        }

        notifyListeners();
      }

      return userCredential;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<UserModel?> getUserFromId(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        return UserModel.fromFirestore(userDoc);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting user from ID: $e");
      }
    }
    return null;
  }


  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _userModel = null;
      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  bool isAdmin() {
    return _userModel?.isAdmin ?? false;
  }
}
