import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp/feedbacks.dart';
import 'login.dart';
import 'register.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:async/async.dart';
import 'home.dart';
import 'admin.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.white,
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
  );
}

Future<void> main() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        // Replace with actual values
        options: FirebaseOptions(
            apiKey: "AIzaSyA224VPPL6VCDZy8NfvVptN1ONT39Vg3R8",
            authDomain: "registerapp-7bb34.firebaseapp.com",
            projectId: "registerapp-7bb34",
            storageBucket: "registerapp-7bb34.appspot.com",
            messagingSenderId: "998172951010",
            appId: "1:998172951010:web:1096b886b0d0b5ab2d79bb",
            measurementId: "G-812V3VBQFD"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Get.to(() => (Login()));
      } else {
        Get.to(() => (Home()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        "/Admin": (context) => const Admin(),
        "/Feedbacks": (context) => const Feedbacks(),
        "/Home": (context) => const Home(),
        "/Login": (context) => const Login(),
      },
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
    return Center(child: CircularProgressIndicator());
  }
}
