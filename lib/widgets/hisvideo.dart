// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wacitt/utils/data_json.dart';

import '../screens/tik/home_page.dart';

class FirstTab extends StatelessWidget {
  late VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
