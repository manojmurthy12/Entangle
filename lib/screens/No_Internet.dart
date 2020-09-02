import 'package:connectivity/connectivity.dart';
import 'package:entangle/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Scaffold No_Connection() {
  return Scaffold(
    body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                maincolor,
                maincolor2,
              ],
            ),
          ),
        ),
        Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  child: Image.asset(
                    'images/no-wifi.png',
                    scale: 4,
                  ),
                  padding: EdgeInsets.all(40),
                ),
              ),
              Text(
                'Please connect to the internet',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
