// ignore_for_file: constant_identifier_photos
import 'package:flutter/material.dart';
import 'package:wacitt/size_config.dart';

import '../models/user.dart';
import '../theme/color.dart';

const int ANIMATED_BODY_MS = 500;

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kphotolNullError = "Please Enter your photo";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kNamelNullError = "Please Enter your name";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}

String? num;
// List categories = [
//   {"photo": "assets/images/plomb.png", "name": "Plumber"},
//   {"photo": "assets/images/screw.png", "name": "Mechanic"},
//   {"photo": "assets/images/build.png", "name": "Barber"},
//   {"photo": "assets/images/paint.png", "name": "Electrician"},
//   {"photo": "assets/images/caliper.png", "name": "Paineter"},
//   {"photo": "assets/images/paint-roller.png", "name": "Builder"},
//   {"photo": "assets/images/screwdriver.png", "name": "Truck driver"},
//   {"photo": "assets/images/excavator.png", "name": "Bricolage"},
// ];

Profil? user;
PhotoProfil? img;
