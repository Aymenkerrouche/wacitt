// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wacitt/widgets/custom_surfix_icon.dart';
import 'package:wacitt/widgets/default_button.dart';
import 'package:wacitt/widgets/form_error.dart';
import 'package:wacitt/size_config.dart';

import '../../../theme/color.dart';
import '../../../utils/constant.dart';
import '../../sign_in/sign_in_screen.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.06),
              Text(
                "Reset password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Please enter your email and we will send to\nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            controller: emailController,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: kPrimaryColor),
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.07),
          DefaultButton(
            text: "Send link",
            press: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  errors.clear();
                });
                passwordReset();
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.07),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "try to login now",
                style: TextStyle(fontSize: getProportionateScreenWidth(16)),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, SignInScreen.routeName),
                child: Text(
                  "  Log in",
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      snkBar(kPrimaryColor, "link was successfully sent, check your inbox",
          "ok", white, () => null, 3);
    } on FirebaseAuthException catch (e) {
      print(e);
      snkBar(red, e.message!, "ok", Colors.grey.shade200, () => null, 4);
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snkBar(Color color,
      String? text, String ok, Color okcolor, Function() ontap, int s) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color.withOpacity(0.5),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '$text',
          style: const TextStyle(color: black),
        ),
      ),
      action: SnackBarAction(label: 'OK', onPressed: ontap, textColor: okcolor),
      elevation: 50,
      duration: Duration(seconds: s),
      shape: const StadiumBorder(side: BorderSide.none),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
