import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:itm_ichtrinkmehr_flutter/web_db/auth.dart';
import 'package:sizer/sizer.dart';
import 'intro/unternehmens_eingabe.dart';
import 'package:theme_manager/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      // Replace with actual values
      options: const FirebaseOptions(
          apiKey: "AIzaSyCktbmvPzOS4O-7w3EMEgGtE3baVRvWGFc",
          authDomain: "buchundschaff-18ad9.firebaseapp.com",
          databaseURL:
              "https://buchundschaff-18ad9-default-rtdb.europe-west1.firebasedatabase.app",
          projectId: "buchundschaff-18ad9",
          storageBucket: "buchundschaff-18ad9.appspot.com",
          messagingSenderId: "47602994221",
          appId: "1:47602994221:web:b4f171d61a27adf675fca4",
          measurementId: "G-LB699M0091"),
    );
  } catch (Exception) {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Stream<User?> user = Auth().currentUser;
  ThemeData whiteTheme = ThemeData(
    // UI
    brightness: Brightness.light,
    backgroundColor: const Color.fromARGB(255, 245, 248, 227),
    cardColor: const Color.fromARGB(255, 173, 173, 173),
    secondaryHeaderColor: Colors.deepOrangeAccent,

    // font
    fontFamily: 'FontShare',
    //text style
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    ),
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: Color(0xff2f2f2f)),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: const Color.fromARGB(255, 107, 109, 108)),
  );

  ThemeData blackTheme = ThemeData(
    // UI
    brightness: Brightness.dark,
    backgroundColor: const Color.fromARGB(255, 29, 29, 29),
    cardColor: const Color(0xffd5dfe8),
    secondaryHeaderColor: Colors.deepOrangeAccent,

    // font
    fontFamily: 'FontShare',
    //text style
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ThemeManager(

        /// WidgetsBinding.instance.window.platformBrightness is used because a
        /// Material BuildContext will not be available outside of the Material app
        defaultBrightnessPreference: BrightnessPreference.system,
        data: (Brightness brightness) => whiteTheme,
        loadBrightnessOnStart: true,
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return Sizer(builder: (context, orientation, deviceType) {
            return MaterialApp(
              theme: theme,
              debugShowCheckedModeBanner: false,
              home: const LoginPage(),
            );
          });
        });
  }
}
