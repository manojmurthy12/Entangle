import 'package:flutter/material.dart';
import 'package:entangle/preferences.dart';

Scaffold signin() {
  return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(32),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Image.asset(
                    'images/entangle.png',
                    scale: 6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Entangle',
                    style: TextStyle(fontFamily: 'Comfortaa', fontSize: 25),
                  )
                ],
              ),
              SizedBox(
                height: 200,
              ),
              RaisedButton(
                color: Colors.white,
                onPressed: handleSignIn,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'images/google.png',
                      scale: 15,
                    ),
                    title: const Text('Sign in with Google',
                        style: TextStyle(
                            fontFamily: 'Staatliches', color: Colors.black)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
