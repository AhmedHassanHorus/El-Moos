import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:easy_localization/easy_localization.dart';

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('account-exists-with-different-credential')) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content:
                Text('the account already exists with a different credential')
                    .tr(),
          ),
        );
      } else if (e.code.contains('invalid-credential')) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: Text('error occurred while accessing credentials').tr(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: Text('some thing went wrong').tr(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text('some thing went wrong').tr(),
        ),
      );
    }
    return user;
  }

  static Future signInFacebook(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user;
    try {
      final facebookLogin = FacebookLogin();

      // bool isLoggedIn = await facebookLogin.isLoggedIn;

      final FacebookLoginResult result = await facebookLogin.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email,
        ],
      );

      String token = result.accessToken!.token;

      final AuthCredential credential = FacebookAuthProvider.credential(token);

      final userCredential = await _auth.signInWithCredential(credential);
      user = userCredential.user;
    } catch (error) {
      print('why $error');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text('some thing went wrong').tr(),
        ),
      );
    }
    return user;
  }
}
