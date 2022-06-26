// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(this.icon,
      {this.onTap,
      this.color,
      this.activeColor = Colors.teal,
      this.isActive = false,
      this.isNotified = false,
      required this.iconActive});
  final String icon;
  final String iconActive;
  final Color? color;
  final Color activeColor;
  final bool isNotified;
  final bool isActive;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(),
          child: isActive
              ? SvgPicture.asset(
                  iconActive,
                  color: activeColor,
                  height: 30,
                  width: 30,
                )
              : SvgPicture.asset(
                  icon,
                  color: color,
                )),
    );
  }
}
