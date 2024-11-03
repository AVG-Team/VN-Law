import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<GoogleSignInAccount?> signOut() async {
    try {
      return await _googleSignIn.signOut();
    } catch (error) {
      throw Exception(error);
    }
  }
}
