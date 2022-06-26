// ignore_for_file: curly_braces_in_flow_control_structures, avoid_returning_null_for_void, use_key_in_widget_constructors, non_constant_identifier_names
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wacitt/screens/home/home_screen.dart';
import 'package:wacitt/widgets/form_error.dart';
import '../../../models/user.dart';
import '../../../theme/color.dart';
import '../../../utils/constant.dart';

class PutInfos extends StatefulWidget {
  @override
  _PutInfosState createState() => _PutInfosState();
}

class _PutInfosState extends State<PutInfos> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String phoneNumber = "";
  String address = "";
  String name = "";
  void _startTimer() {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    });
  }

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future getDoc() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((DocumentSnapshot data) {
      user = Profil.fromJson(data.data() as Map<String, dynamic>);
      user!.phone = data['phone'];
      user!.name = data['name'];
      user!.address = data['address'];
      addressController.text = data['address'];
      nameController.text = data['name'];
      phoneController.text = data['phone'];
      name = user!.name;
      phoneNumber = user!.phone;
      address = user!.address;
    });
  }

  @override
  void initState() {
    super.initState();
    getDoc();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: size.height * 0.05),
          buildPhoneNumberFormField(),
          SizedBox(height: size.height * 0.05),
          buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: size.height * 0.07),
          SizedBox(
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
                updateProfile();
              },
              child: const Text(
                "Done ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue!,
      controller: addressController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: address,
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: kPrimaryColor)),
        labelStyle: const TextStyle(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset("assets/icons/Location point.svg"),
        ),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      onSaved: (newValue) => phoneNumber = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone",
        hintText: phoneNumber,
        labelStyle: const TextStyle(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: kPrimaryColor)),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset("assets/icons/Phone.svg"),
        ),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => name = newValue!,
      controller: nameController,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: kPrimaryColor)),
        labelText: "name",
        hintText: name,
        labelStyle: const TextStyle(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            "assets/icons/User.svg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future updateProfile() async {
    try {
      updateUserDetails(
        nameController.text.trim(),
        phoneController.text.trim(),
        addressController.text.trim(),
      ).then((value) => _startTimer());
    } on FirebaseAuthException catch (e) {
      snkBar(red, e.message!, "ok", red, () => null, 3);
    }
  }

  Future updateUserDetails(String name, String phone, String address) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': name,
      'address': address,
      'phone': phone,
    });
    snkBar(kPrimaryColor, "Profile updated", "ok", white, () => null, 2);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snkBar(Color color,
      String? text, String ok, Color okcolor, Function() ontap, int s) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color.withOpacity(0.5),
      content: Text(
        '$text',
        style: const TextStyle(color: black),
      ),
      action: SnackBarAction(label: 'OK', onPressed: ontap, textColor: okcolor),
      elevation: 50,
      duration: Duration(seconds: s),
      shape: const StadiumBorder(side: BorderSide.none),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
