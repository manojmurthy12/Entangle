import 'package:flutter/material.dart';
import 'package:entangle/main.dart';

class ResourceScreen extends StatefulWidget {
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  @override
  Widget build(BuildContext context) {
    Card buildModule() {
      return Card(
        child: Column(
          children: [
            ListTile(
              leading: Image.asset(
                'images/chapter.png',
                scale: 16,
              ),
              title: Text(
                SelectedCourse[SubjectNumber][TopicNumber][0],
                style:
                    TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
              ),
            ),
            for (SubtopicNumber = 1;
                SubtopicNumber <
                    SelectedCourse[SubjectNumber][TopicNumber].length;
                SubtopicNumber++)
              ListTile(
                title: Text(
                  SelectedCourse[SubjectNumber][TopicNumber][SubtopicNumber],
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
          ],
        ),
      );
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.indigo,
            title: Text(
              Courses[SubjectNumber],
              style: TextStyle(fontFamily: 'Staatliches', color: Colors.white),
            ),
            bottom: TabBar(
                indicatorWeight: 2,
                indicatorColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.video_library),
                    child: Text(
                      'Videos',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  Tab(
                      child: Text(
                        'Files',
                        style: TextStyle(fontSize: 10),
                      ),
                      icon: Icon(
                        Icons.file_download,
                      )),
                ]),
          ),
          body: TabBarView(children: <Widget>[
            ListView(
              children: [
                for (TopicNumber = 0;
                    TopicNumber < SelectedCourse[SubjectNumber].length;
                    TopicNumber++)
                  buildModule(),
              ],
            ),
            ListView(
              children: [
                Center(
                  child: Text(
                    'Nothing to show yet.',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
                  ),
                )
              ],
            ),
          ]),
        ));
  }
}
