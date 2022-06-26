// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wacitt/screens/profile/components/profile_pic.dart';
import 'package:wacitt/widgets/hisvideo.dart';

import '../../widgets/favorites.dart';
import '../../theme/color.dart';
import '../update/update_profil_screen.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.02),
          child: Column(
            children: [
              // profile photo
              ProfilePicture(),
              SizedBox(height: 15),
              // username
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '@Aymen Kerrouche',
                  style: TextStyle(color: black, fontSize: 20),
                ),
              ),
              Text(
                'constantine, Algeria',
                style: TextStyle(
                    color: black, fontSize: 16, fontWeight: FontWeight.w300),
              ),

              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: size.width * 0.25),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.teal), primary: black),
                  onPressed: () {
                    Timer(const Duration(milliseconds: 200), () {
                      Navigator.pushNamed(context, UpdateProfile.routeName);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text('Edit profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: black, fontSize: 20)),
                  ),
                ),
              ),

              // default tab controller
              TabBar(
                indicatorColor: Colors.teal,
                tabs: [
                  Tab(
                    icon: Icon(Icons.videocam, color: black),
                  ),
                  Tab(
                    icon: Icon(Icons.favorite, color: black),
                  ),
                ],
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    FirstTab(),
                    SecondTab(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
