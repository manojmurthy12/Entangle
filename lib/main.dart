import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MaterialApp(home: Splash()));
}

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
        ),
        seconds: 3,
        navigateAfterSeconds: FirstScreen(),
        backgroundColor: Colors.white,
        photoSize: 100.0,
        loaderColor: Colors.black);
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
    );
  }
}
