import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'login.dart';
import 'package:uuid/uuid.dart';
import 'feedbacks.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  Get.to(() => (Login()));
}

class _HomeState extends State<Home> {
  var current_user = "";

  final nameController = TextEditingController();
  final messageController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var user = FirebaseAuth.instance.authStateChanges().listen((user) {
      print(user);
      setState(() {
        current_user = user!.email.toString();
      });
    });
  }

  SendFeedback() {
    final now = new DateTime.now();

    Get.snackbar(
      "Submitting Your Feedback...",
      "please wait while we save your feedback",
      icon: Icon(Icons.message, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
    );

    var u = Uuid();
    var F_ID = u.v1();

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("feedbacks").doc(F_ID);

    //Map

    Map<String, String> topic = {
      "name": nameController.text,
      "email": current_user,
      "phone": phoneController.text,
      "message": messageController.text,
      "datetime": now.toString(),
      "id": F_ID
    };

    documentReference.set(topic).whenComplete(() {
      print("name created");
      nameController.text = "";
      emailController.text = "";
      phoneController.text = "";
      messageController.text = "";

      Get.snackbar(
        "Thanks for Your Feedback...",
        "Feedback submitted successfully",
        icon: Icon(Icons.message, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile(BuildContext context) =>
        MediaQuery.of(context).size.width < 650;

    final _feedbackformKey = GlobalKey<FormState>();

    return new Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Logged in as ${current_user}",
                ),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                Get.to(() => (Feedbacks()));
              },
              child: Text("My feedbacks"),
            )
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text("Submit Feedback"),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () {
                signOut();
              })
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _feedbackformKey,
            child: Container(
              height: 450,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(40, 67, 68, 70),
                    width: 1.0,
                    style: BorderStyle.solid), //Border.all

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              margin: EdgeInsets.only(top: 50),
              width: isMobile(context)
                  ? MediaQuery.of(context).size.width * 0.9
                  : 500,
              child: new Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Feedback Form",
                    style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.person),
                    title: new TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        hintText: "Name",
                      ),
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.phone),
                    title: new TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Phone Number';
                        }
                      },
                      decoration: new InputDecoration(
                        hintText: "Phone",
                      ),
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.email),
                    title: new TextFormField(
                      enabled: false,
                      initialValue: current_user,
                      decoration: new InputDecoration(
                        hintText: "Email",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  new ListTile(
                    leading: const Icon(Icons.message),
                    title: TextFormField(
                      controller: messageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Message';
                        }
                      },
                      maxLines: 4,
                      decoration:
                          InputDecoration(hintText: "Enter your message"),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_feedbackformKey.currentState!.validate()) {
                          SendFeedback();
                        }
                      },
                      child: Text("Submit"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
