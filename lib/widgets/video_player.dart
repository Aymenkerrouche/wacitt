import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class video extends StatefulWidget {
  const video({Key? key, required this.filePath}) : super(key: key);
  final String filePath;
  @override
  State<video> createState() => _videoState();
}

class _videoState extends State<video> {
  late VideoPlayerController _videoPlayerController;

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: VideoPlayer(_videoPlayerController),
    );
  }
}
