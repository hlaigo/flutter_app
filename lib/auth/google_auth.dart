import 'package:aigo/api/restful.dart';
import 'package:aigo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user;

  void getCurrentUser() {
    User? _user = _firebaseAuth.currentUser;
    user = _user;
    logger.e(user);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _account = await _googleSignIn.signIn();
    if (_account != null) {
      GoogleSignInAuthentication _authentication =
          await _account.authentication;
      OAuthCredential _googleCredential = GoogleAuthProvider.credential(
        idToken: _authentication.idToken,
        accessToken: _authentication.accessToken,
      );
      UserCredential _credential =
          await _firebaseAuth.signInWithCredential(_googleCredential);
      if (_credential.user != null) {
        user = _credential.user;
        Restful.requestAuthentication(
            'google', user!.email, user!.providerData.first.uid);
      }
    }
  }
}
