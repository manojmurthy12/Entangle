import 'package:entangle/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:entangle/preferences.dart';
import 'package:entangle/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:entangle/main.dart';

Future<bool> handleSignOut() async {
  setEmail(null);
  setPassword(null);
  auth.signOut();
  logged_in = false;
}

/*Future<bool> checkPersistence() async {
  getEmail().then((value) {
    userEmail = value;
  });
  getPassword().then((value) {
    userPassword = value;
  });
  if (await auth.currentUser != null)
    print('true');
  else
    print('no');
  if (userEmail != null)
    return Future.value(true);
  else
    return Future.value(false);
}*/
