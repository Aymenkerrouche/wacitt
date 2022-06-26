// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:wacitt/screens/tik/allow_infos.dart';
import 'package:wacitt/theme/color.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
  late AnimationController animacontroller;
  late Animation<double> animation;
  String cam = "cam";
  @override
  void initState() {
    _initCamera();
    super.initState();

    animacontroller =
        AnimationController(duration: const Duration(seconds: 90), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animacontroller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    animacontroller.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(
      front,
      ResolutionPreset.high,
      enableAudio: true,
    );
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final pickedFile = await _cameraController.stopVideoRecording();
      _video = File(pickedFile.path);
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(
          filePath: _video.path,
          video: _video,
          cam: 'cam',
        ),
      );
      Navigator.pushReplacement(context, route);
    } else {
      _cameraController.enableAudio;
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
      if (_isRecording = true) {
        Timer(const Duration(seconds: 90), () async {
          final pickedFile = await _cameraController.stopVideoRecording();
          _video = File(pickedFile.path);
          setState(() => _isRecording = false);
          final route = MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => VideoPage(
              filePath: _video.path,
              video: _video,
              cam: 'cam',
            ),
          );
          Navigator.pushReplacement(context, route);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: kPrimaryColor,
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Stack(children: [
          Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: CameraPreview(_cameraController),
                  ),
                ]),
          ),
          _isRecording
              ? Positioned(
                  right: size.width * 0.1,
                  top: size.height * 0.05,
                  child: Container(
                    height: 5,
                    width: size.width * 0.8,
                    child: LinearProgressIndicator(
                      value: animation.value,
                      color: kPrimaryColor,
                      backgroundColor: kPrimaryColor.withOpacity(0.2),
                    ),
                  ),
                )
              : SizedBox(),
        ]),
        floatingActionButton: Container(
          width: size.width * 0.581,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.large(
                heroTag: "h",
                backgroundColor: kPrimaryColor.withOpacity(0.8),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.circle,
                  size: size.width * 0.22,
                ),
                onPressed: () => _recordVideo(),
              ),
              Spacer(),
              FloatingActionButton(
                heroTag: "jk",
                backgroundColor: kPrimaryColor.withOpacity(0.5),
                onPressed: () => _pickVideo(),
                child: const Icon(Icons.image_rounded),
              )
            ],
          ),
        ),
      );
    }
  }

  var _video;
  final picker = ImagePicker();
  VideoPlayerController? _videoPlayerController;

  _pickVideo() async {
    var pickedFile = await picker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 90));
    _video = File(pickedFile!.path);
    _videoPlayerController = VideoPlayerController.file(_video);
    if (_video == null) {
      return;
    }
    await VideoCompress.setLogLevel(0);
    final info = await VideoCompress.compressVideo(
      _video.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    final route = MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => VideoPage(
        filePath: _video.path,
        video: _video,
        cam: '',
      ),
    );
    Navigator.push(context, route);
  }
}

class VideoPage extends StatefulWidget {
  final String filePath;
  final File video;
  final String cam;

  const VideoPage(
      {Key? key,
      required this.filePath,
      required this.video,
      required this.cam})
      : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  bool isLoading = false;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor,backgroundColor: white,));
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
      floatingActionButton: Container(
        width: size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {},
              heroTag: "btn1",
              backgroundColor: red,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            isLoading
                ? FloatingActionButton(
              onPressed: () {},
              heroTag: "btn11",
              backgroundColor: white,
              child:  const CircularProgressIndicator(color: kPrimaryColor)
            )
                : FloatingActionButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (widget.cam == 'cam') {
                        final vid = await VideoCompress.compressVideo(
                          widget.filePath,
                          quality: VideoQuality.MediumQuality,
                          deleteOrigin: false,
                          includeAudio: true,
                        );
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Allow(
                                  filePath: widget.video.path,
                                  file: widget.video,
                                )),
                      );
                    },
                    heroTag: "bt1",
                    backgroundColor: kPrimaryColor,
                    child: const Icon(Icons.check),
                  ),
          ],
        ),
      ),
    );
  }
}
