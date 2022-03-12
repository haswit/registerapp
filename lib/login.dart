import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginformKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Get.to(() => Home());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No User Found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile(BuildContext context) =>
        MediaQuery.of(context).size.width < 650;

    return Scaffold(
        backgroundColor: Color.fromARGB(45, 66, 66, 70),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _loginformKey,
              child: Container(
                margin: EdgeInsets.only(top: 150),
                padding: EdgeInsets.all(30),
                alignment: Alignment.center,
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
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(66, 56, 114, 86),
                        offset: const Offset(
                          3.0,
                          3.0,
                        ),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ]),
                width: isMobile(context) ? 320 : 400,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sign In",
                      style: TextStyle(fontSize: 25, color: Colors.blue),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!value.contains('@')) {
                          return 'Please Enter Valid Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                          if (value.toString().length < 7) {
                            return '8 charecters required for password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            print(emailController.text);
                            // Validate returns true if the form is valid, otherwise false.
                            if (_loginformKey.currentState!.validate()) {
                              setState(() {
                                email = emailController.text;
                                password = passwordController.text;
                              });
                              userLogin();
                            }
                          },
                          child: Text("Login"),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Don't have account?"),
                    TextButton(
                        onPressed: () {
                          print("Pressed");
                          Get.to(() => (Register()));
                        },
                        child: Text("Create account",
                            style: TextStyle(color: Colors.blue))),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
