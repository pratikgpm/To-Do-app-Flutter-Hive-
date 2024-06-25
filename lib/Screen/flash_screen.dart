import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:do_it/Screen/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class flashScreen extends StatefulWidget {
  const flashScreen({super.key});

  @override
  State<flashScreen> createState() => _flashScreenState();
}

class _flashScreenState extends State<flashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<Offset> title_animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    controller.forward();
    title_animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    Timer(
      Duration(milliseconds: 2500),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => homeScreen(),
            ));
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff330066)],
            end: Alignment.bottomLeft,
            begin: Alignment.topRight,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: FadeTransition(
                        opacity: animation,
                        child: Lottie.asset(
                          'assets/images/final.json',
                          repeat: false,
                          frameRate: FrameRate.max,
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: title_animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: Text(
                          "Let's do it ",
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontFamily: 'Flash',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Developed by Daily_Routine",
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade300),
                      ),
                      Text(
                        "ppsutar044@gmail.com",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      )
                    ]),
              )
            ],
          )),
    );
  }
}
