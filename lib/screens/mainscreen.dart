// ignore_for_file: must_be_immutable,camel_case_types

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lab_15/screens/task_screen.dart";
import "../classes/constants.dart";
import "accountscreen.dart";
import "editscreen.dart";
import "package:lab_15/classes/user.dart";

class mainScreen extends StatefulWidget {
  mainScreen(this.email);
  myUser user = myUser("name", "email", "date");
  var email;
  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  var data;
  bool isloading = true;
  @override
  void initState() {
    get();
    super.initState();
  }

  get() async {
    data = await getUser(widget.email);
    widget.user.date = data["date"];
    widget.user.name = data["name"];
    widget.user.email = data["email"];
    if (data["tasks"] != null) {
      List<dynamic> tasksData = data["tasks"];
      List<Task> tasks = tasksData.map((taskData) {
        String name = taskData['name'];
        String date = taskData['date'];
        return Task(name, date);
      }).toList();
      widget.user.tasks = tasks;
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: const Text("Task List"),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => accountScreen(widget.user)));
                },
              );
            }),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color.fromARGB(255, 24, 20, 211),
                      title: const Text(
                        'Confirm Exit',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Are you sure you want to exit?',
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('No',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.of(context).pop(); // Dismiss the dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Yes',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pop(); // Dismiss the dialog
                            Navigator.of(context)
                                .pop(); // Pop the current screen
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: widget.user.tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(widget.user.tasks[index].name),
                        subtitle: Text(widget.user.tasks[index].date),
                        trailing: Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          editScreen(widget.user, index),
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      setState(() {});
                                    }
                                  });
                                },
                                iconSize: 20,
                                icon: Icon(Icons.edit),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () async {
                                  widget.user.tasks.removeAt(index);
                                  CollectionReference usersCollection =
                                      FirebaseFirestore.instance
                                          .collection('users');
                                  DocumentReference userDocRef = usersCollection
                                      .doc(widget.user.email.toString());

                                  await userDocRef.set({
                                    'tasks': widget.user.tasks
                                        .map((task) => task.toMap())
                                        .toList(),
                                  }, SetOptions(merge: true));
                                  setState(() {});
                                },
                                iconSize: 20,
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskScreen(widget.user)))
                  .then((value) {
                if (value == true) {
                  setState(() {});
                }
              });
            },
          );
        }),
      )),
    );
  }
}
