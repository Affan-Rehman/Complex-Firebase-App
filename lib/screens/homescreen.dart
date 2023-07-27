// ignore_for_file: must_be_immutable,camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lab_15/screens/mainscreen.dart';
import 'package:lab_15/screens/newuser.dart';

class homeScreen extends StatefulWidget {
  homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  var con1 = TextEditingController();

  var con2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: const Text("Login Please"),
        ),
        body: Column(
          children: [
            TextField(
              controller: con1,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: con2,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    signin(con1.text, con2.text, context);
                  },
                  child: const Text("Login"));
            }),
            Builder(builder: (context) {
              return Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => registrationScreen()),
                          );
                        },
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      )),
    );
  }

  void signin(var emailAddress, var password, var context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password)
          .then((value) {
        User? user = FirebaseAuth.instance.currentUser;
        con1.clear();
        con2.clear();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => mainScreen(user!.email.toString())));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
