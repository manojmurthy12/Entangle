import 'package:flutter/material.dart';
import 'package:entangle/main.dart';

class Videotags extends StatefulWidget {
  @override
  _VideotagsState createState() => _VideotagsState();
}

class _VideotagsState extends State<Videotags> {
  int Subtopic = 0;
  Card buildVideoPage(int Subtopic) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              SelectedCourse[SubjectNumber][TopicNumber][Subtopic],
              style: TextStyle(fontFamily: 'Oswald'),
            ),
          ),
          ListTile(
            leading: Image.asset(
              'images/play.png',
              scale: 28,
            ),
            title: Text(
              'Leibnitzs Theorem - Problem 1',
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          SelectedCourse[SubjectNumber][TopicNumber][0],
          style: TextStyle(color: Colors.white, fontFamily: 'Staatliches'),
        ),
      ),
      body: ListView(
        children: [
          for (Subtopic = 1;
              Subtopic < SelectedCourse[SubjectNumber][TopicNumber].length;
              Subtopic++)
            buildVideoPage(Subtopic)
        ],
      ),
    );
  }
}
