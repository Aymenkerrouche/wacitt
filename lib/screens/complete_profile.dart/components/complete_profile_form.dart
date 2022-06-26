// ignore_for_file: curly_braces_in_flow_control_structures, avoid_returning_null_for_void, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wacitt/screens/login_success/login_success_screen.dart';
import 'package:wacitt/widgets/custom_surfix_icon.dart';
import 'package:wacitt/widgets/default_button.dart';
import 'package:wacitt/widgets/form_error.dart';
import '../../../size_config.dart';
import '../../../theme/color.dart';
import '../../../utils/constant.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? phoneNumber;
  String? address;
  String? name;

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

  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildPhoneNumberFormField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          DefaultButton(
            text: "continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                // Navigator.pushNamed(context, OtpScreen.routeName);
                setState(() {
                  errors.clear();
                });
                completeProfile();
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
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
      decoration: const InputDecoration(
        labelText: "Address",
        hintText: "Enter your phone",
        labelStyle: TextStyle(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      onSaved: (newValue) => phoneNumber = newValue,
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
      decoration: const InputDecoration(
        labelText: "Phone",
        hintText: "Enter your phone number",
        labelStyle: TextStyle(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => name = newValue,
      controller: nameController,
      decoration: const InputDecoration(
        labelText: "name",
        hintText: "Enter your name",
        labelStyle: TextStyle(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  Future completeProfile() async {
    var mail = FirebaseAuth.instance.currentUser!.email;
    try {
      addUserDetails(nameController.text.trim(), phoneController.text.trim(),
              addressController.text.trim(), mail!)
          .then((value) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>  LoginSuccessScreen()),
              (route) => false));
    } on FirebaseAuthException catch (e) {
      snkBar(red, e.message!, "ok", red, () => null, 3);
    }
  }

  Future addUserDetails(
      String name, String phone, String address, String email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
    });
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
