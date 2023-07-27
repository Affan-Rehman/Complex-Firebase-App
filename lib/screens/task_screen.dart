// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lab_15/classes/user.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatelessWidget {
  var con = TextEditingController();
  myUser user;
  // ignore: use_key_in_widget_constructors
  TaskScreen(this.user);

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
            title: const Text("Add task"),
          ),
          body: Column(children: [
            TextField(
              controller: con,
              decoration: const InputDecoration(
                labelText: "Enter task",
              ),
            ),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () async {
                    DateTime currentDate = DateTime.now();
                    String dateString =
                        DateFormat('yyyy-MM-dd').format(currentDate);

                    user.tasks.add(Task(con.text.trim(), dateString));

                    CollectionReference usersCollection =
                        FirebaseFirestore.instance.collection('users');
                    DocumentReference userDocRef =
                        usersCollection.doc(user.email.toString());

                    await userDocRef.set({
                      'tasks': user.tasks.map((task) => task.toMap()).toList(),
                    }, SetOptions(merge: true));
                  },
                  child: const Text("Save"));
            })
          ]),
        ),
      ),
    );
  }
}
