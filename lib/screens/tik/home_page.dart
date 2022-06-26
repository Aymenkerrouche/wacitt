// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../widgets/column_social_icon.dart';
import '../../widgets/left_panel.dart';
import '../../theme/color.dart';
import '../../widgets/tik_tok_icons.dart';
import '../../utils/data_json.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        children: List.generate(items.length, (index) {
          return VideoPlayerItem(
            videoUrl: items[index]['videoUrl'],
            size: size,
            name: items[index]['name'],
            caption: items[index]['caption'],
            profileImg: items[index]['profileImg'],
          );
        }),
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String? videoUrl;
  final String? name;
  final String? caption;
  final String? profileImg;
  final String? shares;
  VideoPlayerItem(
      {Key? key,
      required this.size,
      this.name,
      this.caption,
      this.profileImg,
      this.shares,
      this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videoUrl!)
      ..initialize().then((value) {
        _videoController.play();
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
        });
        _videoController.setLooping(true);
      },
      child: RotatedBox(
        quarterTurns: -1,
        child: Container(
            height: widget.size.height,
            width: widget.size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  decoration: BoxDecoration(color: black),
                  child: Stack(
                    children: <Widget>[
                      VideoPlayer(_videoController),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(),
                          child: isPlaying(),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 20, bottom: 10),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              LeftPanel(
                                size: widget.size,
                                name: "${widget.name}",
                                caption: "${widget.caption}",
                              ),
                              RightPanel(
                                size: widget.size,
                                profileImg: "${widget.profileImg}",
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class RightPanel extends StatefulWidget {
  RightPanel({
    Key? key,
    required this.size,
    this.profileImg,
  }) : super(key: key);
  final Size size;
  final String? profileImg;
  @override
  State<RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  bool favori = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: widget.size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: widget.size.height * 0.3,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                getProfile(),
                favori
                    ? Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: IconButton(
                            onPressed: () {
                              switch (favori) {
                                case false:
                                  favori = true;
                                  break;
                                case true:
                                  favori = false;
                                  break;
                                default:
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 45,
                            )),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: IconButton(
                            onPressed: () {
                              switch (favori) {
                                case false:
                                  favori = true;
                                  break;
                                case true:
                                  favori = false;
                                  break;
                                default:
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: white,
                              size: 45,
                            )),
                      ),
                getIcons(TikTokIcons.chat_bubble, 35.0),
                IconButton(
                    onPressed: () {
                      Share.share("text");
                    },
                    icon: Icon(
                      TikTokIcons.reply,
                      color: white,
                      size: 28,
                    )),
                IconButton(
                    color: white,
                    onPressed: () async {
                      final Uri tlpn = Uri(
                        scheme: 'tel',
                        path: "0798121607",
                      );
                      await launchUrl(tlpn);
                    },
                    icon: Icon(
                      Icons.call,
                      size: 35,
                    ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class Video extends StatefulWidget {
  final String? videoUrl;
  Video({Key? key, this.videoUrl}) : super(key: key);
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videoUrl!)
      ..initialize().then((value) {
        _videoController.pause();
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 40,
            color: white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
        });
      },
      child: RotatedBox(
        quarterTurns: 0,
        child: Container(
          decoration: BoxDecoration(color: black),
          child: Stack(
            children: <Widget>[
              VideoPlayer(_videoController),
              Center(
                child: Container(
                  child: isPlaying(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
