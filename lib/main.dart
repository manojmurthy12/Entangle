import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

int _semester = 0;
int _branch = 0;
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
        title: Text(
          'presents',
          style: TextStyle(fontFamily: 'Comfortaa'),
        ),
        navigateAfterSeconds: FirstScreen(),
        backgroundColor: Colors.white,
        photoSize: 100.0,
        loaderColor: Colors.black);
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Scaffold preferences() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select your Preferences'),
      ),
      body: Container(
        color: Colors.grey,
        child: Center(
          child: Column(
            children: [
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      _semester = 1;
                    });
                  },
                  child: Text('sem1')),
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      _semester = 1;
                    });
                  },
                  child: Text('sem2')),
            ],
          ),
        ),
      ),
    );
  } //make sure to store the preferences in a seperate variable

  @override
  Widget build(BuildContext context) {
    return preferences(); //edit this 'preferences' function with drop down box and stuff...
  }
}
