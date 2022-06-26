import 'package:flutter/material.dart';
import 'package:wacitt/size_config.dart';

import '../../../theme/color.dart';
import 'complete_profile_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text("Complete Profile", style: headingStyle),
                const Text(
                  "fill your details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.07),
                CompleteProfileForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
