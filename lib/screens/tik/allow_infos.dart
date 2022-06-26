// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path/path.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wacitt/widgets/video_player.dart';

import '../../helper/keyboard.dart';
import '../../models/category.dart';
import '../../services/firebase_api.dart';
import '../../theme/color.dart';
import 'root_app.dart';

class Allow extends StatefulWidget {
  const Allow({Key? key, required this.filePath, required this.file})
      : super(key: key);
  final String filePath;
  final File file;

  @override
  State<Allow> createState() => _AllowState();
}

class _AllowState extends State<Allow> {
  TextEditingController textController = TextEditingController();
  bool allowCall = false;
  bool allowLocation = false;
  bool allowMsg = false;
  String? dropdown;
  UploadTask? task;
  bool isLoading = false;
  Category? category;
  List categories = [];
  @override
  void initState() {
    super.initState();
    getCatrgories();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Cancel'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(
                height: 250,
                width: size.width * 0.4,
                child: video(
                  filePath: widget.filePath,
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    maxLines: 1,
                    controller: textController,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: kPrimaryColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: kPrimaryColor)),
                      labelText: "Title",
                      labelStyle: const TextStyle(color: kPrimaryColor),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonHideUnderline(
                      child: GFDropdown(
                        padding: const EdgeInsets.all(15),
                        borderRadius: BorderRadius.circular(15),
                        dropdownButtonColor: kPrimaryColor.withOpacity(0.15),
                        value: dropdown,
                        onChanged: (newValue) {
                          setState(() {
                            dropdown = newValue as String?;
                          });
                        },
                        items: categories
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.call),
                      ),
                      Expanded(
                          child: Text(
                        "allow calls",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                      GFToggle(
                        onChanged: (val) {
                          allowCall = val!;
                        },
                        enabledTrackColor: kPrimaryColor,
                        value: false,
                        type: GFToggleType.ios,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.forum_outlined,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        'allow messages',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                      GFToggle(
                        onChanged: (val) {
                          allowMsg = val!;
                        },
                        enabledTrackColor: kPrimaryColor,
                        value: false,
                        type: GFToggleType.ios,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.location_on_outlined),
                      ),
                      Expanded(
                          child: Text(
                        'allow location',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                      GFToggle(
                        onChanged: (val) {
                          allowLocation = val!;
                        },
                        enabledTrackColor: kPrimaryColor,
                        value: false,
                        type: GFToggleType.ios,
                      ),
                    ],
                  ),
                  task != null
                      ? buildUploadStatus(task!)
                      : SizedBox(
                          width: double.infinity,
                          height: size.height * 0.07,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              primary: Colors.white,
                              backgroundColor: kPrimaryColor,
                            ),
                            onPressed: () {
                              uploadFile().then((value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RootAppp()),
                                );
                              });
                              KeyboardUtil.hideKeyboard(context);
                            },
                            child: const Text(
                              "Upload",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future uploadFile() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    final fileName = DateTime.now().toString();
    final destination = 'files/$user/$fileName';
    setState(() {
      task = FirebaseApi.uploadFile(destination, widget.file);
      if (task == null) return;
    });
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL().then((value) {
      setVideo(user, dropdown!, textController.text.trim(), allowCall, allowMsg,
          allowLocation, value);
    });
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          Size size = MediaQuery.of(context).size;
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(0);

            return SizedBox(
              width: double.infinity,
              height: size.height * 0.07,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  primary: Colors.white,
                  backgroundColor: kPrimaryColor,
                ),
                onPressed: () {},
                child: Text(
                  '$percentage %',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator(
              color: kPrimaryColor,
            );
          }
        },
      );

  Future setVideo(String userID, String category, String title, bool call,
      bool msg, bool location, link) async {
    print(category);
    print(link);
    await FirebaseFirestore.instance.collection("video").add({
      'userID': userID,
      'Category': category,
      'title': title,
      'call': call,
      'msg': msg,
      'location': location,
      'link': link,
    });
    print(
        "===============================================================================");
  }

  Future getCatrgories() async {
    await FirebaseFirestore.instance
        .collection("Catégories")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          category = Category.fromJson(element.data());
          categories.add(category!.name);
        });
      });
    });
  }
}
