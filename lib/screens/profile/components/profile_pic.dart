// ignore_for_file: unnecessary_string_interpolations

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wacitt/theme/color.dart';

import '../../../models/user.dart';
import '../../../utils/constant.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool done = false;
  String urlDownload = "";
  @override
  void initState() {
    super.initState();
    getProfilePicture();
  }

  File? image;
  UploadTask? uploadTask;
  Future pickImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 10);
      if (image == null) return;
      final imageTemprary = File(image.path);
      setState(() => this.image = imageTemprary);
      final ref = FirebaseStorage.instance.ref(FirebaseAuth.instance.currentUser!.uid);
      uploadTask = ref.putFile(imageTemprary);
      final snapshot = await uploadTask!.whenComplete(() => {});
      urlDownload = await snapshot.ref.getDownloadURL();
      setProfilePicture(urlDownload);
      setState(() {
        urlDownload;
      });
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print('failed : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pickPic(),
      child: SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            done
                ? CircleAvatar(
                    backgroundColor: white,
                    backgroundImage: NetworkImage("$urlDownload"),
                  )
                : Image.asset("assets/images/user.png"),
            Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: Colors.white),
                    ),
                    primary: Colors.white,
                    backgroundColor: const Color(0xFFF5F6F9),
                  ),
                  onPressed: () => pickPic(),
                  child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> pickPic() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      backgroundColor: const Color(0xFFF5F6F9),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 3),
            width: size.width * 0.1,
            height: 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: black),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: black,
                ),
                title: const Text('Camera', style: TextStyle(color: black)),
                onTap: () => pickImage(ImageSource.camera)),
          ),
          const Divider(
            height: 15,
            color: white,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListTile(
                leading: const Icon(
                  Icons.image,
                  color: black,
                ),
                title: const Text('Gallery', style: TextStyle(color: black)),
                onTap: () => pickImage(ImageSource.gallery)),
          ),
        ],
      ),
    );
  }

  Future setProfilePicture(String path) async {
    await FirebaseFirestore.instance
        .collection("photos")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'photo': path,
    }).then((value) => getProfilePicture());
  }

  Future getProfilePicture() async {
    FirebaseFirestore.instance
        .collection('photos')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot data) {
      if (data.data() == null) {
      } else {
        img = PhotoProfil.fromJson(data.data() as Map<String, dynamic>);
        urlDownload = img!.photo;
        setState(() {
          done = true;
        });
      }
    });
  }
}
