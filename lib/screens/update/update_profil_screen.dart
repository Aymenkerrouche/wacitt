import 'package:flutter/material.dart';

import 'components/body.dart';

class UpdateProfile extends StatelessWidget {
  static String routeName = "/updateProfile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
