// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wacitt/screens/complete_profile.dart/components/complete_profile_form.dart';
import 'package:wacitt/screens/login_success/login_success_screen.dart';

import '../../theme/color.dart';
import '../complete_profile.dart/compete_profile_screen.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CompleteProfileScreen();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor));
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("register"),
                ),
                body: Body());
          }
        });
  }
}
