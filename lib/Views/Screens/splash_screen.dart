import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../res/global.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Duration duration = const Duration(seconds: 5);
    Timer(duration, () {
      Navigator.of(context).pushReplacementNamed((Global.isLogged==false)?'login':'/');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 2 * pi),
                duration: Duration(seconds: 4),
                builder: (BuildContext context, double val, Widget? child) {
                  return Transform.rotate(
                    angle: val,
                    child: Icon(
                      Icons.menu_book_sharp,
                      size: 200,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              TweenAnimationBuilder(
                tween: Tween<Offset>(
                  begin: Offset(-150, 0),
                  end: Offset(0, 0),
                ),
                duration: Duration(seconds: 4),
                builder: (BuildContext context, Offset Offset, Widget? child) {
                  return Transform.translate(
                    offset: Offset,
                    child: Text(
                      "NoteKeeper",
                      style: const TextStyle(fontSize: 35, color: Colors.black),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
