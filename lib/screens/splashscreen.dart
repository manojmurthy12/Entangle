import 'package:entangle/main.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:entangle/signin.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        image: Image.asset(
          'images/Logo.png',
          scale: 4,
        ),
        title: Text('presents'),
        seconds: 2,
        navigateAfterSeconds: FirstScreen(),
        backgroundColor: Colors.white,
        photoSize: 100.0,
        loaderColor: Colors.blue[900]);
  }
}
