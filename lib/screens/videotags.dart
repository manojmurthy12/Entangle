import 'package:entangle/screens/resources.dart';
import 'package:flutter/material.dart';
import 'package:entangle/main.dart';
import 'package:entangle/tags/VideoNames.dart';
import 'package:entangle/tags/VideoLinks.dart';
import 'package:entangle/screens/Video_player.dart';
import 'package:entangle/preferences.dart';

class Videotags extends StatefulWidget {
  @override
  _VideotagsState createState() => _VideotagsState();
}

Icon save = Icon(
  Icons.bookmark_border,
);
Icon saved = Icon(
  Icons.bookmark,
  color: Colors.indigo,
);

class _VideotagsState extends State<Videotags> {
  int Subtopic = 0;
  Container buildVideoPage(int Subtopic) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text(
              SelectedCourse[SubjectNumber][TopicNumber][Subtopic],
              style: TextStyle(fontFamily: 'Staatliches'),
            ),
          ),
          for (int video = 0;
              video <
                  SelectedCourseVideo[SubjectNumber][TopicNumber][Subtopic - 1]
                      .length;
              video++)
            Column(
              children: [
                FlatButton(
                  onPressed: () {
                    setState(() {
                      fromSave = false;
                      VideoNumber = video;
                      SubtopicNumber = Subtopic;
                      print(VideoNumber);
                      print(SubtopicNumber);
                      print(SelectedCourseVideolinks[SubjectNumber][TopicNumber]
                          [Subtopic - 1][VideoNumber]);
                      VideoUrl = SelectedCourseVideolinks[SubjectNumber]
                          [TopicNumber][Subtopic - 1][VideoNumber];
                      VideoTitle = SelectedCourseVideo[SubjectNumber]
                          [TopicNumber][Subtopic - 1][VideoNumber];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => player(),
                        ),
                      );
                    });
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.play_circle_filled,
                      color: Colors.indigo,
                    ),
                    title: Text(
                      SelectedCourseVideo[SubjectNumber][TopicNumber]
                          [Subtopic - 1][video],
                    ),
                    trailing: IconButton(
                        icon: (!SavedVideo.contains(
                                SelectedCourseVideo[SubjectNumber][TopicNumber]
                                    [Subtopic - 1][video]))
                            ? save
                            : saved,
                        onPressed: () {
                          setState(() {
                            if (!SavedVideo.contains(
                                SelectedCourseVideo[SubjectNumber][TopicNumber]
                                    [Subtopic - 1][video])) {
                              SavedVideo.add(SelectedCourseVideo[SubjectNumber]
                                  [TopicNumber][Subtopic - 1][video]);
                              SavedLink.add(
                                  SelectedCourseVideolinks[SubjectNumber]
                                      [TopicNumber][Subtopic - 1][video]);
                              setSavedVideo(SavedVideo);
                              setSavedLink(SavedLink);
                            } else {
                              SavedVideo.remove(
                                  SelectedCourseVideo[SubjectNumber]
                                      [TopicNumber][Subtopic - 1][video]);
                              SavedLink.remove(
                                  SelectedCourseVideolinks[SubjectNumber]
                                      [TopicNumber][Subtopic - 1][video]);
                              setSavedVideo(SavedVideo);
                              setSavedLink(SavedLink);
                            }
                          });
                        }),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                )
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (SelectedCourseVideo.length == 0)
      return WillPopScope(
        onWillPop: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResourceScreen(),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResourceScreen(),
                ),
              ),
            ),
            backgroundColor: Colors.indigo,
            title: Text(
              SelectedCourse[SubjectNumber][TopicNumber][0],
              style: TextStyle(color: Colors.white, fontFamily: 'Staatliches'),
            ),
          ),
          backgroundColor: Colors.white,
          body: nothingtoshow(),
        ),
      );
    else
      return WillPopScope(
        onWillPop: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResourceScreen(),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResourceScreen(),
                ),
              ),
            ),
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
        ),
      );
  }
}
