import "dart:io";

import "package:app_settings/app_settings.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:lab_15/classes/user.dart";
import "package:permission_handler/permission_handler.dart";

// ignore: camel_case_types, must_be_immutable
class accountScreen extends StatefulWidget {
  myUser user;
  
  // ignore: use_key_in_widget_constructors
  accountScreen(this.user);

  @override
  State<accountScreen> createState() => _accountScreenState();
}

class _accountScreenState extends State<accountScreen> {
  XFile? i;
  bool isGranted = false;

  Future<void> requestGalleryPermission() async {
    PermissionStatus status = await Permission.photos.request();
    if (status.isGranted) {
      isGranted = true;
    }
    if (status.isPermanentlyDenied) {
        AppSettings.openAppSettings();
      
    }
  }
  
  @override
  void initState() {
    requestGalleryPermission();
    super.initState();
  }

  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("User Details"),
        ),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: h * 0.25,
                  width: w * 0.5,
                  child: i == null
                      ? const CircleAvatar()
                      : CircleAvatar(
                          backgroundImage: FileImage(File(i!.path)),
                        )),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                color: Colors.black,
                onPressed: () async {
                  if (isGranted) {
                    await picker
                        .pickImage(source: ImageSource.gallery)
                        .then((value) {
                      if (value != null) {
                        i = value;
                      }
                      setState(() {});
                    });
                  }
                  else{
                    requestGalleryPermission();
                  }
                },
              )
            ],
          ),
          Card(
            elevation: 10,
            child: Container(
              constraints:
                  const BoxConstraints.tightForFinite(width: double.infinity),
              child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.name.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(widget.user.email.toString(), style: const TextStyle(fontSize: 20)),
                    Text(widget.user.date.toString(), style: const TextStyle(fontSize: 20)),
                  ]),
            ),
          )
        ]),
      )),
    );
  }
}
