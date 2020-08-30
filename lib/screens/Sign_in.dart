import 'package:flutter/material.dart';
import 'package:entangle/preferences.dart';
import 'package:entangle/main.dart';

Scaffold signin() {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(32),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Image.asset(
                'images/entangle.png',
                scale: 6,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Entangle',
                style: TextStyle(
                    fontFamily: mainfont,
                    fontSize: 25,
                    color: Colors.grey[800]),
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
                    title: Text('Sign in with Google',
                        style: TextStyle(
                            fontFamily: mainfont, color: Colors.blueGrey)),
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
