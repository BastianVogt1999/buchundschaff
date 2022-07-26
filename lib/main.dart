import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:itm_ichtrinkmehr_flutter/intro/carrousel_intro.dart';
import 'package:sizer/sizer.dart';
import 'intro/unternehmens_eingabe.dart';

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
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      );
    });
  }
}
