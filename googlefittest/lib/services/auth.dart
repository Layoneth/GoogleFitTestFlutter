import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  // Sign in with Google
  Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount _user = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _user.authentication;
      AuthCredential _credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken,
        accessToken: _googleAuth.accessToken,
      );
      AuthResult authResult = await _auth.signInWithCredential(_credential);
      print(authResult.user.email);
      return authResult.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future singOut() async {
    try {
      await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}