import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      print('Error signing in: $error');
      return null;
    }
  }

  Future<GoogleSignInAccount?> signOut() async {
    try {
      return await _googleSignIn.signOut();
    } catch (error) {
      print('Error signing out: $error');
      return null;
    }
  }
}
