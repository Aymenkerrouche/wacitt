// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

import '../screens/tik/home_page.dart';
import '../utils/data_json.dart';

class SecondTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: GridView.builder(
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              mainAxisExtent: 220),
          itemBuilder: (context, index) {
            return Video(
              videoUrl: items[index]['videoUrl'],
            );
          }),
    );
  }
}
