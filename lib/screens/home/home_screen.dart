// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, unused_element, non_constant_identifier_names, avoid_types_as_parameter_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wacitt/models/category.dart';
import 'package:wacitt/screens/profile/profile_screen.dart';
import 'package:wacitt/screens/splash/splash_screen.dart';
import 'package:wacitt/screens/tik/root_app.dart';
import '../../theme/color.dart';
import 'components/drawer_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/homepage";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Category? category;
  List<Category> categories = [];
  bool done = false;
  @override
  void initState() {
    getCatrgories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: white,
        drawer: Drawer(
          child: Material(
            color: kPrimaryColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
              child: Column(
                children: [
                  Text(
                    "Wacitt",
                    style: TextStyle(color: kPrimaryColor, fontSize: 33),
                  ),
                  Divider(
                    thickness: 1,
                    height: size.height * 0.05,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  DrawerItem(
                    name: 'Home',
                    icon: "assets/icons/home.svg",
                    color: kPrimaryColor,
                    onPressed: () => onItemPressed(context, index: 0),
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  DrawerItem(
                      name: 'messages',
                      icon: "assets/icons/msg.svg",
                      color: Colors.indigoAccent,
                      onPressed: () => onItemPressed(context, index: 1)),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  DrawerItem(
                      name: 'Favorites',
                      icon: "assets/icons/heart.svg",
                      color: Colors.red.shade700,
                      onPressed: () => onItemPressed(context, index: 2)),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  DrawerItem(
                      name: 'Videos',
                      icon: "assets/icons/video.svg",
                      color: Colors.orange,
                      onPressed: () => onItemPressed(context, index: 3)),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Divider(
                    thickness: 1,
                    height: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  DrawerItem(
                      name: 'Profile',
                      icon: "assets/icons/profile.svg",
                      color: Colors.indigo,
                      onPressed: () => onItemPressed(context, index: 4)),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  DrawerItem(
                    name: 'languages',
                    icon: "assets/icons/translate.svg",
                    color: blue.shade500,
                    onPressed: () => onItemPressed(context, index: 5),
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  DrawerItem(
                      name: 'settings',
                      icon: "assets/icons/Settings.svg",
                      color: Colors.grey,
                      onPressed: () => onItemPressed(context, index: 6)),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Divider(
                    thickness: 1,
                    height: 10,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  DrawerItem(
                      name: 'Log out',
                      icon: "assets/icons/logout.svg",
                      color: black,
                      onPressed: () => onItemPressed(context, index: 7)),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: const Text(
            'WACITT',
            style: TextStyle(color: white, fontSize: 20),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          centerTitle: false,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.02),
            child: done? GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: size.width * 0.06,
                mainAxisSpacing: size.width * 0.07,
                children: List.generate(categories.length, (index) {
                  return InkWell(
                    splashColor: kPrimaryColor.withOpacity(0.2),
                    onTap: () {
                      Navigator.pushNamed(context, RootAppp.routeName);
                    },
                    child: Stack(children: [
                      Container(
                        height: size.height * 0.25,
                        width: size.width * 0.5,
                        padding: EdgeInsets.all(15),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: white,
                              border: Border.all(
                                  color: kPrimaryColor.withOpacity(0.9),
                                  width: 5)),
                          child: Image.network(
                            categories[index].picture,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            categories[index].name,
                            style: TextStyle(
                                color: white,
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.bold),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: kPrimaryColor.withOpacity(0.95),
                          ),
                        ),
                      )
                    ]),
                  );
                })):Center(child: CircularProgressIndicator(color: kPrimaryColor),)
                ));
  }

  void onItemPressed(BuildContext context, {required int index}) {
    switch (index) {
      case 7:
        FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
            .pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false));
        break;
      case 4:
        Timer(const Duration(milliseconds: 200), () {
          Navigator.pushNamed(context, ProfileScreen.routeName);
        });
        break;
    }
  }

  Future getCatrgories() async {
    await FirebaseFirestore.instance
        .collection("Catégories")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          category = Category.fromJson(element.data());
          categories.add(category!);
          done = true;
        });
      });
    });
  }
}
