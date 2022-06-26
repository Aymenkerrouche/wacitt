// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import '../theme/color.dart';
Widget getIcons(icon, size) {
  return Icon(icon, color: white, size: size);
}

Widget getProfile() {
  return Container(
    width: 50,
    height: 60,
    child: Stack(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: white),
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage("assets/profil.jpg"), fit: BoxFit.cover)),
        ),
        Positioned(
            bottom: 3,
            left: 18,
            child: Container(
              width: 20,
              height: 20,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: primary),
              child: const Center(
                  child: Icon(
                Icons.add,
                color: white,
                size: 15,
              )),
            ))
      ],
    ),
  );
}


