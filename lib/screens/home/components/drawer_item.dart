// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/color.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {Key? key,
      required this.name,
      required this.onPressed,
      required this.color,
      required this.icon})
      : super(key: key);

  final String name;
  final String icon;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kPrimaryColor.withOpacity(0.2),
      onTap: onPressed,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.8), shape: BoxShape.circle),
              child: SvgPicture.asset(
                icon,
                color: white,
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Text(
              name,
              style: TextStyle(
                  color: black.withOpacity(0.8),
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
