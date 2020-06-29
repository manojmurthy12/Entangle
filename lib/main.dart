import 'package:entangle/tags/modules.dart';
import 'package:flutter/material.dart';
import 'screens/splashscreen.dart';
import 'screens/home.dart';
import 'preferences.dart';
import 'screens/resources.dart';
import 'tags/courses.dart';
import 'tags/ImageTags.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' show json;
import "package:http/http.dart" as http;
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(home: Splash()));
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
String SelectedName = '';
String SelectedSem =
    ''; // this variable will be used to store the present status of the branch and Semester
String SelectedBranch = '';
List<String> imageTag = [];
String CourseImage = '';
TextEditingController controller;

int SubjectNumber = 0;
int TopicNumber = 0;
int SubtopicNumber = 0;
String name = '';
String semester = 'P-Cycle';
String branch = 'ECE';
String phoneNumber;
GoogleUserCircleAvatar userImage;
GoogleSignInAccount currentUser;
String contactText;

FirebaseUser user;
final phoneController = TextEditingController();
final codeController = TextEditingController();

List<String> Courses = [];

List<List<List<String>>> SelectedCourse = [];

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
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        currentUser = account;
      });
    });
    _googleSignIn.signInSilently();

    if (currentUser != null)
      userImage = GoogleUserCircleAvatar(
        identity: currentUser,
      );

    getSem().then((value) {
      setState(() {
        semester = value;
        SelectedSem = value;
      });
    });
    getBranch().then((value) {
      setState(() {
        branch = value;
        SelectedBranch = value;
      });
    });
    getName().then((value) {
      setState(() {
        name = value;
        SelectedName = value;
      });
    });
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Drawer setting() {
    return Drawer(child: preference());
  }

  Container preference() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Image.asset(
            'images/course.jpg',
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: currentUser,
            ),
            title: Text(currentUser.displayName ?? ''),
            subtitle: Text(currentUser.email ?? ''),
          ),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
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
              style: TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
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
                        color: Colors.grey, fontFamily: 'Staatliches'),
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
              style: TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
            ),
            trailing: DropdownButton<String>(
              autofocus: true,
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
                      color: Colors.grey,
                      fontFamily: 'Staatliches',
                    ),
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
          FlatButton(
            onPressed: () {
              setState(() {
                setBranch(branch);
                setSem(semester);
                if (name != '' || name != null) setName(name);
              });
            },
            child: Card(
              color: Colors.indigo,
              child: Text(
                '  Submit  ',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Staatliches',
                    fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }

  Scaffold preferenceView() {
    if (currentUser != null)
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Select your Preferences',
            style: TextStyle(color: Colors.indigo, fontFamily: 'Bebas Neue'),
          ),
        ),
        body: preference(),
      );
    else
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Form(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'images/entangle.png',
                        scale: 4,
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
                    height: 40,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    onPressed: _handleSignIn,
                    child: ListTile(
                      leading: Image.asset(
                        'images/google.png',
                        scale: 15,
                      ),
                      title: const Text('SIGN IN with Google',
                          style: TextStyle(
                              fontFamily: 'Staatliches', color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
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
          style: TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
        ),
      ),
    );
  }

  Scaffold Home(List image) {
    imageTag = image;
    return Scaffold(
      endDrawer: setting(),
      appBar: AppBar(
        leading: Image.asset(
          'images/entangle.png',
          scale: 20,
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.indigo,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          )
        ],
        backgroundColor: Colors.white,
        title: Text(
          'My Courses',
          style: TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
        ),
      ),
      body: ListView(
        children: [
          Card(
            color: Colors.lightBlueAccent,
            child: Image.asset(
              'images/courses.jpg',
              scale: 1,
            ),
          ),
          for (int index = 0; index < image.length; index++)
            buildSubject(index, imageTag[index]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
    if (currentUser != null) {
      if (SelectedSem == 'P-Cycle') {
        SelectedCourse = Pcycletopics;
        Courses = PcycleCourses;
        return bottomNavigate(Home(Pcycle));
      }
      if (SelectedSem == 'C-Cycle') {
        SelectedCourse = Ccycletopics;
        Courses = CcycleCourses;
        return bottomNavigate(Home(Ccycle));
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Third') {
        SelectedCourse = null;
        Courses = Ece3Courses;
        return bottomNavigate(Home(Ece3));
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Fourth') {
        SelectedCourse = null;
        Courses = Ece4Courses;
        return bottomNavigate(Home(Ece4));
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Fifth') {
        SelectedCourse = null;
        Courses = Ece5Courses;
        return bottomNavigate(Home(Ece5));
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Sixth') {
        SelectedCourse = null;
        Courses = Ece6Courses;
        return bottomNavigate(Home(Ece6));
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Seventh') {
        SelectedCourse = null;
        Courses = Ece7Courses;
        return bottomNavigate(Home(Ece7));
      }
      if (SelectedBranch == 'ECE' && SelectedSem == 'Eighth') {
        SelectedCourse = null;
        Courses = Ece8Courses;
        return bottomNavigate(Home(Ece8));
      }
      if (SelectedBranch == 'Civil' && SelectedSem == 'Third') {
        SelectedCourse = null;
        Courses = Civil3Courses;
        return bottomNavigate(Home(Civil3));
      } else
        return preferenceView();
    } else
      return preferenceView();
  }
}
