// ignore_for_file: camel_case_types, must_be_immutable, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class registrationScreen extends StatelessWidget {
  var con1 = TextEditingController();
  var con2 = TextEditingController();
  var con3 = TextEditingController();
  var con4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign up please"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(children: [
          TextField(
            controller: con1,
            decoration: InputDecoration(labelText: "Full name"),
          ),
          TextField(
            controller: con2,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: con3,
            decoration: InputDecoration(labelText: "Password"),
          ),
          TextField(
            controller: con4,
            decoration: InputDecoration(labelText: "Confirm Password"),
          ),
          ElevatedButton(
              onPressed: () {
                signUp(con2.text, con3.text);
              },
              child: Text("Sign Up")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Log in",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          )
        ]),
      )),
    );
  }

  void signUp(var emailAddress, var password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      )
          .then((value) {
        DateTime currentDate = DateTime.now();
        String date = DateFormat('yyyy-MM-dd').format(currentDate);
        add(con1.text, con2.text, date);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> add(var name, var email, var date) async {
    User? user= FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance
  .collection("users")
  .doc(user!.email.toString())
  .set({'name': name, 'email': email, 'date': date});
    
  }
}
