// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import "package:lab_15/classes/constants.dart";

// ignore: camel_case_types
class dataScreen extends StatefulWidget {
  var email;
  dataScreen(this.email);
  @override
  State<dataScreen> createState() => _dataScreenState();
}

// ignore: camel_case_types
class _dataScreenState extends State<dataScreen> {
  var data;
  bool isloading = true;
  @override
  void initState() {
    get();
    super.initState();
  }

  get()async  {
    data= await getUser(widget.email);
    setState(() {
      isloading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(title: Text("User data")),
        body: isloading?CircularProgressIndicator():ListTile(leading: Text(data["name"]),),
      )),
    );
  }
}
