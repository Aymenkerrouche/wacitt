// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:wacitt/screens/tik/home_page.dart';

import '../../widgets/bottombar_item.dart';
import '../../theme/color.dart';
import 'camera/cam.dart';
import 'profil.dart';

class RootAppp extends StatefulWidget {
  const RootAppp({
    Key? key,
  }) : super(key: key);
  static String routeName = "/tik";
  @override
  _RootApppState createState() => _RootApppState();
}

class _RootApppState extends State<RootAppp> with TickerProviderStateMixin {
  int activeTab = 0;
  List barItems = [
    {
      "icon": "assets/icons/house.svg",
      "active_icon": "assets/icons/house.svg",
      "page": HomePage(),
    },
    {
      "icon": "assets/icons/add.svg",
      "active_icon": "assets/icons/add.svg",
      "page": const CameraPage(),
    },
    {
      "icon": "assets/icons/profile.svg",
      "active_icon": "assets/icons/profile.svg",
      "page": UserProfilePage(),
    },
  ];

//====== set animation=====
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 3),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  animatedPage(page) {
    return FadeTransition(child: page, opacity: _animation);
  }

  void onPageChanged(int index) {
    _controller.reset();
    setState(() {
      activeTab = index;
    });
    _controller.forward();
  }

//====== end set animation=====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getBottomBar(),
      body: barItems[activeTab]["page"],
    );
  }

  Widget getBottomBar() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.07,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.teal, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(1, 1))
      ]),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  barItems.length,
                  (index) => BottomBarItem(
                        barItems[index]["icon"],
                        isActive: activeTab == index,
                        activeColor: white,
                        color: white.withOpacity(0.5),
                        onTap: () {
                          onPageChanged(index);
                        },
                        iconActive: barItems[index]["active_icon"],
                      )))),
    );
  }
}
