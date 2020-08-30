import 'package:entangle/screens/Sign_in.dart';
import 'package:entangle/tags/VideoLinks.dart';
import 'package:entangle/tags/modules.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'screens/splashscreen.dart';
import 'screens/home.dart';
import 'preferences.dart';
import 'screens/resources.dart';
import 'tags/courses.dart';
import 'tags/ImageTags.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' show json;
import "package:http/http.dart" as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:share/share.dart';

GoogleSignIn googleSignIn;
void main() {
  runApp(MaterialApp(home: Splash()));
}

Color maincolor = Color.fromRGBO(113, 170, 239, 1);
Color maincolor2 = Color.fromRGBO(209, 144, 226, 1);
String mainfont = 'OpenSans';
String SelectedName = '';
String SelectedSem =
    ''; // this variable will be used to store the present status of the branch and Semester
String SelectedBranch = '';
List<String> imageTag = [];
String CourseImage = '';
String VideoUrl;
String VideoTitle;
List<String> UpnextVideos;

TextEditingController controller;

int SubjectNumber = 0;
int TopicNumber = 0;
int SubtopicNumber = 0;
int VideoNumber = 0;
String name = '';
String semester = 'P-Cycle';
String branch = 'ECE';
String phoneNumber;
GoogleUserCircleAvatar userImage;
GoogleSignInAccount currentUser;
String contactText;
bool fromSave = false;

List<String> Courses = [];

List<List<List<String>>> SelectedCourse = [];

List<List<List<List>>> SelectedCourseVideo = [];

List<List<List<List>>> SelectedCourseVideolinks = [];

List<String> SavedVideo = [];
List<String> SavedLink = [];

Container nothingtoshow() {
  return Container(
    child: Center(
      child: Column(
        children: [
          Image.asset('images/empty.jpg'),
          Text(
            'Nothing to show yet',
            style: TextStyle(color: Colors.blueGrey),
          )
        ],
      ),
    ),
  );
}

Container nothingtoshow2() {
  return Container(
    child: Center(
      child: Column(
        children: [
          Image.asset('images/empty2.jpg'),
          Text(
            'Nothing to show yet',
            style: TextStyle(color: Colors.blueGrey),
          )
        ],
      ),
    ),
  );
}

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key}) : super(key: key);
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {}

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Drawer setting() {
    return Drawer(child: preference());
  }

  Container preference() {
    return Container(
      color: maincolor,
      child: ListView(
        children: [
          Image.asset(
            'images/setting.jpg',
            scale: 6,
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [maincolor, Colors.white],
                    end: Alignment.topCenter,
                    begin: Alignment.bottomCenter)),
            child: Column(
              children: [
                ListTile(
                  leading: GoogleUserCircleAvatar(
                    identity: currentUser,
                  ),
                  title: Text(currentUser.displayName ?? ''),
                  subtitle: Text(currentUser.email ?? ''),
                ),
                Container(
                  child: FlatButton(
                    color: Colors.grey[100],
                    child: const Text(
                      'Sign out',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    onPressed: handleSignOut,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 80),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: Image.asset(
                    'images/semester.png',
                    scale: 15,
                  ),
                  title: Text(
                    'Semester',
                    style: TextStyle(color: Colors.white, fontFamily: mainfont),
                  ),
                  trailing: DropdownButton<String>(
                    value: semester,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    items: <String>[
                      'P-Cycle',
                      'C-Cycle',
                      'Third',
                      'Fourth',
                      'Fifth',
                      'Sixth',
                      'Seventh',
                      'Eighth'
                    ].map<DropdownMenuItem<String>>((String value1) {
                      return DropdownMenuItem<String>(
                        value: value1,
                        child: Text(
                          value1.toString(),
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: mainfont,
                              fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        semester = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: Image.asset(
                    'images/branch.png',
                    scale: 15,
                  ),
                  title: Text(
                    'Branch',
                    style: TextStyle(color: Colors.white, fontFamily: mainfont),
                  ),
                  trailing: DropdownButton<String>(
                    autofocus: false,
                    value: branch,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    items: <String>[
                      'ECE',
                      'CSE',
                      'EEE',
                      'Civil',
                      'Mechanical',
                      'ISE',
                      'Other',
                    ].map<DropdownMenuItem<String>>((String value2) {
                      return DropdownMenuItem<String>(
                        value: value2,
                        child: Text(
                          value2.toString(),
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: mainfont,
                              fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        branch = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: Colors.blue[800], width: 5)),
                    color: maincolor,
                    onPressed: () {
                      setState(() {
                        setBranch(branch);
                        setSem(semester);
                        if (name != '' || name != null) setName(name);
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      '  SUBMIT  ',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto-bold',
                          fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                FlatButton.icon(
                  onPressed: () {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.quantumloop.weplay'); //TODO: Change the app id
                  },
                  icon: Icon(
                    Icons.share,
                    color: Colors.white60,
                  ),
                  label: Text(
                    'Share this app with your friends',
                    style: TextStyle(color: Colors.white60),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Scaffold preferenceView() {
    if (currentUser != null)
      return Scaffold(
        body: preference(),
      );
    else
      return signin();
  }

  FlatButton buildSubject(int course, String image) {
    return FlatButton(
      onPressed: () {
        setState(() {
          CourseImage = image;
          SubjectNumber = course;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResourceScreen(),
          ),
        );
      },
      child: ListTile(
        leading: Image.asset(
          'courseImages/$image.png',
          scale: 15,
        ),
        title: Text(
          Courses[course],
          style: TextStyle(
              color: Colors.grey[800], fontFamily: mainfont, fontSize: 13),
        ),
      ),
    );
  }

  WillPopScope Home(List image) {
    imageTag = image;
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        drawer: setting(),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
          backgroundColor: maincolor,
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [maincolor, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Card(
                  color: Colors.lightBlueAccent,
                  child: Image.asset(
                    'images/MainBanner.jpg',
                    scale: 1,
                  ),
                ),
              ),
              for (int index = 0; index < image.length; index++)
                buildSubject(index, imageTag[index]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        currentUser = account;
      });
    });
    googleSignIn.signInSilently();

    getSem().then((value) {
      setState(() {
        SelectedSem = value;
      });
    });
    getBranch().then((value) {
      setState(() {
        SelectedBranch = value;
      });
    });
    getName().then((value) {
      setState(() {
        SelectedName = value;
      });
    });

    getSavedVideo().then((value) {
      setState(() {
        SavedVideo = value;
      });
    });
    getSavedLink().then((value) {
      setState(() {
        SavedLink = value;
      });
    });

    if (currentUser != null) {
      if (SelectedSem == 'P-Cycle') {
        SelectedCourse = Pcycletopics;
        Courses = PcycleCourses;
        for (int i = 0; i < PcycleVideoLinks.length; i++) {
          SelectedCourseVideolinks.add([]);
          SelectedCourseVideo.add([]);
          for (int j = 0; j < PcycleVideoLinks[i].length; j++) {
            SelectedCourseVideolinks[i].add([]);
            SelectedCourseVideo[i].add([]);
            for (int k = 0; k < PcycleVideoLinks[i][j].length; k++) {
              var temp = PcycleVideoLinks[i][j][k].keys.toList();
              var temp2 = PcycleVideoLinks[i][j][k].values.toList();
              SelectedCourseVideolinks[i][j].add(temp);
              SelectedCourseVideo[i][j].add(temp2);
            }
          }
        }
        return bottomNavigate(Home(Pcycle), context);
      }
      if (SelectedSem == 'C-Cycle') {
        SelectedCourse = Ccycletopics;
        Courses = CcycleCourses;
        for (int i = 0; i < CcycleVideoLinks.length; i++) {
          SelectedCourseVideolinks.add([]);
          SelectedCourseVideo.add([]);
          for (int j = 0; j < CcycleVideoLinks[i].length; j++) {
            SelectedCourseVideolinks[i].add([]);
            SelectedCourseVideo[i].add([]);
            for (int k = 0; k < CcycleVideoLinks[i][j].length; k++) {
              var temp = CcycleVideoLinks[i][j][k].keys.toList();
              var temp2 = CcycleVideoLinks[i][j][k].values.toList();
              SelectedCourseVideolinks[i][j].add(temp);
              SelectedCourseVideo[i][j].add(temp2);
            }
          }
        }
        return bottomNavigate(Home(Ccycle), context);
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Third') {
        SelectedCourse = null;
        Courses = Ece3Courses;
        return bottomNavigate(Home(Ece3), context);
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Fourth') {
        SelectedCourse = null;
        Courses = Ece4Courses;
        return bottomNavigate(Home(Ece4), context);
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Fifth') {
        SelectedCourse = null;
        Courses = Ece5Courses;
        return bottomNavigate(Home(Ece5), context);
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Sixth') {
        SelectedCourse = null;
        Courses = Ece6Courses;
        return bottomNavigate(Home(Ece6), context);
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Seventh') {
        SelectedCourse = null;
        Courses = Ece7Courses;
        return bottomNavigate(Home(Ece7), context);
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Eighth') {
        SelectedCourse = null;
        Courses = Ece8Courses;
        return bottomNavigate(Home(Ece8), context);
      }
      if (SelectedBranch == 'Civil' && SelectedSem == 'Third') {
        SelectedCourse = null;
        Courses = Civil3Courses;
        return bottomNavigate(Home(Civil3), context);
      } else
        return preferenceView();
    } else
      return preferenceView();
  }
}
