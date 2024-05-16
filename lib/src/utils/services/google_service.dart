import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["https://mail.google.com"]);

  Future<String?> signInGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    if (googleAuth.accessToken == null) {
      return null;
    }
    return googleAuth.accessToken;
  }
  Future<void> signOut() async {
     await _googleSignIn.signOut();
  }
}
