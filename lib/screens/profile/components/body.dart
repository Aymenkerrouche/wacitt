// ignore_for_file: unused_element

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wacitt/screens/splash/splash_screen.dart';
import 'package:wacitt/screens/update/update_profil_screen.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _startTimer() {
      Timer(const Duration(milliseconds: 200), () {
        Navigator.pushNamed(context, UpdateProfile.routeName);
      });
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePicture(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User.svg",
            press: () => _startTimer(),
          ),
          ProfileMenu(
            text: "My videos",
            icon: "assets/icons/video.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/logout.svg",
            press: () {
              Timer(const Duration(milliseconds: 200), () {
                FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                        (route) => false));
              });
              
            },
          ),
        ],
      ),
    );
  }
}
