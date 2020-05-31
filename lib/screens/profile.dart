import 'package:flutter/material.dart';
import 'package:entangle/main.dart';

Scaffold profile() {
  return Scaffold(
    body: ListView(
      children: [
        Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'images/profile.png',
              scale: 3,
            ),
            ListTile(
              title: Column(
                children: [
                  Text(
                    SelectedName,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Staatliches',
                        fontSize: 30),
                  ),
                  Text(
                    SelectedSem,
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Staatliches',
                        fontSize: 15),
                  ),
                  Text(
                    SelectedBranch,
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Staatliches',
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
