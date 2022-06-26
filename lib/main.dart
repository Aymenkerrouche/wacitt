// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wacitt/routes.dart';
import 'package:wacitt/screens/home/home_screen.dart';
import 'package:wacitt/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wacitt',
      theme: theme(),
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? HomeScreen.routeName
          : SplashScreen.routeName,
      routes: routes,
    );
  }
}
