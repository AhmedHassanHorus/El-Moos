import 'package:el_moos/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path:
        'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return

      MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'El-Moos',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.green.shade900,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }

            if (snapshot.hasData) {
              if (snapshot.data!.isAnonymous ||
                  snapshot.data!.emailVerified ||
                  snapshot.data!.providerData.any((element) =>
                  element.providerId == 'facebook.com' ||
                      element.providerId == 'google.com')) {
                return const HomePage();
              }
            }
            return AuthPage();
          },
        ),

    );
  }
}