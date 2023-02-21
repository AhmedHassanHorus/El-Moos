import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('El-Moos'),
          ),
          ListTile(
              leading: Icon(
                Icons.language,
                size: MediaQuery.of(context).size.width / 8,
              ),
              title: Text(
                'change lang'.tr(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 22,
                ),
              ),
              onTap: () {
                context.locale != Locale('ar')
                    ? context.setLocale(Locale('ar'))
                    : context.setLocale(Locale('en'));
              }),
          SizedBox(height: 8,),
          const Divider(),
          SizedBox(height: 8,),
          ListTile(
              leading: Icon(
                Icons.request_page,
                size: MediaQuery.of(context).size.width / 8,
              ),
              title: Text(
                "get_your_rewards".tr(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 22,
                ),
              ),
              onTap: () async {
                final MailOptions mailOptions = MailOptions(
                  subject: 'طلب تحويل نقاط',
                  recipients: ['elmoosedu@gmail.com'],
                  isHTML: false,
                );

                await FlutterMailer.send(mailOptions);
              }),
          SizedBox(height: 8,),
          Divider(),
          SizedBox(height: 8,),
          ListTile(
              leading: Icon(
                Icons.exit_to_app,
                size: MediaQuery.of(context).size.width / 8,
              ),
              title: Text(
                'logout'.tr(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 22,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('are you sure').tr(),
                          content: Text('do you want to logout').tr(),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                              },
                              child: Text('no').tr(),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(ctx);
                                if (FirebaseAuth
                                    .instance.currentUser!.isAnonymous) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .delete();
                                  await FirebaseAuth.instance.currentUser!
                                      .delete();
                                } else if (FirebaseAuth
                                        .instance.currentUser!.displayName !=
                                    null) {
                                  try {
                                    await GoogleSignIn().signOut();
                                  } catch (_) {
                                    await FacebookLogin().logOut();
                                  }
                                  await FirebaseAuth.instance.signOut();
                                } else {
                                  await FirebaseAuth.instance.signOut();
                                }
                              },
                              child:const Text('yes').tr(),
                            ),
                          ],
                        ));
              }),
        ],
      ),
    );
  }
}
