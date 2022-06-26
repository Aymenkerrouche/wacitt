import 'package:flutter/material.dart';
import 'package:wacitt/screens/update/components/infos.dart';

import '../../../theme/color.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                const Text("Update Profile",
                    style: TextStyle(
                        color: black,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        height: 1.5)),
                SizedBox(height: size.height * 0.01),
                const Text(
                  "Fill the form to update your details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.05),
                PutInfos(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
