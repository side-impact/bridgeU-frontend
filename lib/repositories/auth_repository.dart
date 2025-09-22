import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '325813816592-pkcb89ff7s2aemfgstn4ap4rl8rin9qo.apps.googleusercontent.com',
  );
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      _user = await _googleSignIn.signIn();
      return _user;
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    _user = null;
  }
}
