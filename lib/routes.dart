import 'package:wacitt/screens/forgot_password/forgot_password_screen.dart';
import 'package:wacitt/screens/login_success/login_success_screen.dart';
import 'package:wacitt/screens/otp/otp_screen.dart';
import 'package:wacitt/screens/profile/profile_screen.dart';
import 'package:wacitt/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:wacitt/screens/update/update_profil_screen.dart';
import 'screens/tik/root_app.dart';
import 'screens/home/home_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  UpdateProfile.routeName: (context) => UpdateProfile(),
  RootAppp.routeName: (context) => RootAppp(),
};
