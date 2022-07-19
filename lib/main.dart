import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:itm_ichtrinkmehr_flutter/intro/carrousel_intro.dart';
import 'package:sizer/sizer.dart';
import 'intro/unternehmens_eingabe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData lightTheme = ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
        primarySwatch: MaterialColor(
          0x00000000,
          const <int, Color>{
            50: Color(0xff000000),
            100: Color(0xff181818),
            200: Color(0xff1c1c1c),
            300: Color(0xff2b2b2b),
            400: Color(0xff323232),
            500: Color(0xff5a5959),
            600: Color(0xff7d7d7d),
            700: Color(0xffa0a0a0),
            800: Color(0xffbbbbbb),
            900: Color(0xffc9c9c9)
          },
        ),
        primaryColor: Color(0xff000000),
        primaryColorBrightness: Brightness.light,
        primaryColorLight: Color(0xff00fff1),
        primaryColorDark: Color(0xff00adb5),
        bottomAppBarColor: Color(0xff029bff),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Colors.white),
        ),
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(selectedItemColor: Color(0xff6ef5db)),
        cardColor: Color(0xff00adb5),
        dividerColor: Color(0x1fae90ff),
        backgroundColor: Color(0xff1a1817),
        focusColor: Color(0x1a6c4613));

    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        theme: lightTheme,
        home: LoginPage(),
      );
    });
  }
}
