import 'package:entangle/main.dart';
import 'package:entangle/screens/Sign_in.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:entangle/preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
      ],
    );
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        currentUser = account;
      });
    });
    googleSignIn.signInSilently();

    if (currentUser != null)
      userImage = GoogleUserCircleAvatar(
        identity: currentUser,
      );

    getSem().then((value) {
      setState(() {
        semester = value;
        SelectedSem = value;
      });
    });
    getBranch().then((value) {
      setState(() {
        branch = value;
        SelectedBranch = value;
      });
    });
    getName().then((value) {
      setState(() {
        name = value;
        SelectedName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        image: Image.asset(
          'images/Logo.gif',
          scale: 1,
        ),
        seconds: 3,
        navigateAfterSeconds: FirstScreen(),
        backgroundColor: Colors.white,
        photoSize: 100.0,
        loaderColor: Colors.white);
  }
}
