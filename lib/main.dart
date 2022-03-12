import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';
import 'register.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:async/async.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.white,
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
  );
}

void main() {
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     // Replace with actual values
  //     options: FirebaseOptions(
  //         apiKey: "AIzaSyBpIlnO7tUdObjxpwp3b1ycAYCS7KxJLBY",
  //         authDomain: "registerapp-3215.firebaseapp.com",
  //         projectId: "registerapp-3215",
  //         storageBucket: "registerapp-3215.appspot.com",
  //         messagingSenderId: "329188789876",
  //         appId: "1:329188789876:web:e787abdbec7f6d32634b21"),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Flutter App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Login(),
    );
  }
}
