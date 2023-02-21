
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'authCard.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _lastEmail = '';
  bool _signedUp = false;
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  void _submit( String userName, String email, String password,
      bool authState, BuildContext ctx) async {
    UserCredential authResponse;
    try {
      setState(() {
        _isLoading = true;
      });
      if (authState) {
        authResponse = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (!authResponse.user!.emailVerified) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(ctx).errorColor,
              content: Text('this email is not verified').tr(),
            ),
          );
        }
      } else {
        if (_signedUp && _lastEmail == email) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('we sent a message to verify your email').tr(),
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        authResponse = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResponse.user!.uid)
            .set({
          'userName': userName,
          'userEmail': email,
          'userPoints': 0,
          'like_list': [],
          'dislike_list': [],

        });
        await _auth.currentUser!.sendEmailVerification();

        await _auth.signOut();

        _signedUp = true;
        _lastEmail = email;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('we sent a message to verify your email').tr(),
            backgroundColor: Theme.of(context).accentColor,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      setState(() {
        _isLoading = false;
      });
      String errorMessage = 'an error accord, Please try again later'.tr();
      if (error.message != null) {
        errorMessage = error.message!;
      }
      ScaffoldMessenger.of(ctx).clearSnackBars();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(ctx).errorColor,
          content: Text(errorMessage),
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      String errorMessage = error.toString();
      print(error);
      if (errorMessage.contains('invalid-email')) {
        errorMessage = 'invalid-email';
      } else if (errorMessage.contains('invalid-password')) {
        errorMessage = 'invalid-password';
      } else if (errorMessage.contains('email-already-in-use')) {
        errorMessage = 'email-already-in-use';
      } else if (errorMessage.contains('user-not-found')) {
        errorMessage = 'user-not-found';
      } else if (errorMessage.contains('wrong-password')) {
        errorMessage = 'wrong-password';
      } else if (errorMessage.contains('network-request-failed')) {
        errorMessage = 'network error';
      }
      ScaffoldMessenger.of(ctx).clearSnackBars();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(ctx).errorColor,
          content: Text(errorMessage).tr(),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String _selectedLang = context.locale.toString();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 18),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 18),
                  child: PopupMenuButton<String>(
                    child: Text(
                      _selectedLang == 'ar' ? 'arabic'.tr() : 'english'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width / 20,
                      ),
                    ),
                    onSelected: (String result) {
                      setState(() {
                        _selectedLang = result;
                      });
                      context.setLocale(Locale(_selectedLang));
                    },
                    itemBuilder: (BuildContext ctx) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'en',
                        child: Text(
                          'english'.tr(),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 20,
                            color: Color(0xff1B5E20),
                          ),
                        ).tr(),
                      ),
                      PopupMenuItem<String>(
                        value: 'ar',
                        child: Text(
                          'arabic'.tr(),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 20,
                            color: Color(0xff1B5E20),
                          ),
                        ).tr(),
                      ),
                    ],
                  ),
                ),
                AuthCard(_submit, _isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
