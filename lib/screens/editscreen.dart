// ignore_for_file: must_be_immutable, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../classes/user.dart';

class editScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  editScreen(this.user, this.no);
  myUser user;
  int no;
  var con = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: const Text("Update task"),
        ),
        body: Column(children: [
          TextField(
            controller: con,
            decoration: const InputDecoration(labelText: "Update details"),
          ),
          ElevatedButton(
              onPressed: () async {
                user.tasks[no].name = con.text.trim();
                CollectionReference usersCollection =
                    FirebaseFirestore.instance.collection('users');
                DocumentReference userDocRef =
                    usersCollection.doc(user.email.toString());

                await userDocRef.set({
                  'tasks': user.tasks.map((task) => task.toMap()).toList(),
                }, SetOptions(merge: true));
              },
              child: const Text("Update"))
        ]),
      )),
    );
  }
}
