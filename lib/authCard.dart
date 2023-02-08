import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';

import 'package:flutter/services.dart';

class AuthCard extends StatefulWidget {
  final bool isLoading;

  final Function submit;
  AuthCard(this.submit, this.isLoading);
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final key = GlobalKey<FormState>();
  bool loading = false;
  String _userName = '';
  var firstSkip = true;
  var _passwordGet = false;
  String _email = '';
  String _password = '';
  var _authState = true;
  String _userType = '';

  void _saveForm() {

    if (!key.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    key.currentState!.save();

    widget.submit( _userName.trim(), _email.trim(), _password.trim(),
        _authState, context);
  }

  void _sendChangePassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('we sent a password reset email').tr(),
          backgroundColor: Theme.of(context).accentColor,
        ),
      );
    } catch (e) {
      String errorMessage = e.toString();
      print(e);
      if (errorMessage.contains('invalid-email')) {
        errorMessage = 'invalid-email';
      } else if (errorMessage.contains('user-not-found')) {
        errorMessage = 'user-not-found';
      } else if (errorMessage.contains('network-request-failed')) {
        errorMessage = 'network error';
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(errorMessage).tr(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 18),
          child: Form(
            key: key,
            child: Column(
              children: [
                if (!_authState && !_passwordGet)
                  TextFormField(
                    key: ValueKey('userName'),
                    textCapitalization: TextCapitalization.words,
                    onSaved: (value) {
                      _userName = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 3) {
                        return 'wrong name'.tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'user name'.tr(),
                      labelStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                    ),
                  ),
                TextFormField(
                  key: ValueKey('email'),
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) {
                    _email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'wrong email'.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'email address'.tr(),
                    labelStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 25,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                if (!_passwordGet)
                  TextFormField(
                    key: ValueKey('password'),
                    onSaved: (value) {
                      _password = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'wrong password'.tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'password'.tr(),
                      labelStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                    ),
                    obscureText: true,
                  ),

                SizedBox(
                  height: MediaQuery.of(context).size.width / 28,
                ),
                if (widget.isLoading || loading) CircularProgressIndicator(),
                if (!widget.isLoading && !loading)
                  Padding(
                    padding:EdgeInsets.all(
    MediaQuery.of(context).size.width / 40,
    ),
                    child: ElevatedButton(
style: ButtonStyle(shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),

),
  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
  ),

                      onPressed: _passwordGet ? _sendChangePassword : _saveForm,
                      child: Text(
                        _passwordGet
                            ? 'send'
                            : _authState
                                ? 'login'
                                : 'sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 20,
                        ),
                      ).tr(),
                    ),
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 28,
                ),
                if (!widget.isLoading && !loading && !_passwordGet)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          User? user = await Authentication.signInWithGoogle(
                              context: context);
                          final response = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .get();
                          if (!response.exists) {
                            print('ok');
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .set({
                              'userName': user.displayName,
                              'userEmail': user.email,
                              'userPoints': 0,
                            });
                          }
                        } catch (e) {
                          setState(() {
                            loading = false;
                          });
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.width / 40,
                            0,
                            MediaQuery.of(context).size.width / 40),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: const AssetImage(
                                  "assets/images/icons/google_logo.png"),
                              height: MediaQuery.of(context).size.width / 18,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: context.locale == Locale('en')
                                      ? MediaQuery.of(context).size.width / 40
                                      : 0,
                                  right: context.locale == Locale('ar')
                                      ? MediaQuery.of(context).size.width / 40
                                      : 0),
                              child: Text(
                                'sign in with google'.tr(),
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 20,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                if (!widget.isLoading && !loading && !_passwordGet)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          User? user =
                              await Authentication.signInFacebook(context);
                          final response = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .get();
                          if (!response.exists) {
                            print('ok');
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .set({
                              'userName': user.displayName,
                              'userEmail': user.email,
                              'userPoints': 0,
                            });
                          }
                        } catch (e) {
                          print('ok  $e');
                          setState(() {
                            loading = false;
                          });
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.width / 40,
                            0,
                            MediaQuery.of(context).size.width / 40),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.facebook,
                              size: MediaQuery.of(context).size.width / 15,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: context.locale == Locale('ar')
                                      ? 0
                                      : MediaQuery.of(context).size.width / 40,
                                  right: context.locale == Locale('ar')
                                      ? MediaQuery.of(context).size.width / 40
                                      : 0),
                              child: Text(
                                'sign in with facebook'.tr(),
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                if (!widget.isLoading && !loading)
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TextButton(
                      onPressed: () async {
                        // widget.skip();

                        setState(() {
                          _passwordGet = !_passwordGet;
                        });
                      },
                      child: Text(
                        _passwordGet ? 'i remembered' : 'forgot password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 20,
                        ),
                      ).tr(),
                    ),
                  ]),
                if (!widget.isLoading && !loading && !_passwordGet)

                      TextButton(
                        onPressed: () {
                          setState(() {
                            _authState = !_authState;
                          });
                        },
                        child: Text(
                          _authState
                              ? 'create new account'.tr()
                              : 'already have an account'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 20,
                          ),
                        ),
                      ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
