import 'package:flutter/material.dart';
import 'package:entangle/main.dart';
import 'videotags.dart';

class ResourceScreen extends StatefulWidget {
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  int Topic = 0;
  @override
  Widget build(BuildContext context) {
    FlatButton buildModule(int Topic) {
      return FlatButton(
        onPressed: () {
          setState(() {
            TopicNumber = Topic;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Videotags()));
        },
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Image.asset(
                  'courseImages/$CourseImage.png',
                  scale: 16,
                ),
                title: Text(
                  SelectedCourse[SubjectNumber][Topic][0],
                  style:
                      TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
                ),
              ),
              for (SubtopicNumber = 1;
                  SubtopicNumber < SelectedCourse[SubjectNumber][Topic].length;
                  SubtopicNumber++)
                ListTile(
                  leading: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  title: Text(
                    SelectedCourse[SubjectNumber][Topic][SubtopicNumber],
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        fontFamily: 'Oswald'),
                  ),
                ),
            ],
          ),
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
                if (SelectedCourse == null)
                  nothingtoshow2()
                else
                  for (Topic = 0;
                      Topic < SelectedCourse[SubjectNumber].length;
                      Topic++)
                    buildModule(Topic),
              ],
            ),
            ListView(
              children: [
                FlatButton(
                    onPressed: () {
                      nothingtoshow();
                    },
                    child: Text('download'))
              ],
            ),
          ]),
        ));
  }
}
