import 'package:entangle/tags/modules.dart';
import 'package:flutter/material.dart';
import 'screens/splashscreen.dart';
import 'screens/home.dart';
import 'preferences.dart';
import 'screens/resources.dart';
import 'tags/courses.dart';

void main() {
  runApp(MaterialApp(home: Splash()));
}

String SelectedName = '';
String SelectedSem =
    ''; // this variable will be used to store the present status of the branch and Semester
String SelectedBranch = '';
TextEditingController controller;

int SubjectNumber = 0;
int TopicNumber = 0;
int SubtopicNumber = 0;
String semester = 'P-Cycle';
String branch = 'ECE';
String name = '';

List<String> Courses = [];

List<List<List<String>>> SelectedCourse = [];

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key}) : super(key: key);
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Drawer setting() {
    return Drawer(child: preference());
  }

  Container preference() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Image.asset(
            'images/settings.jpg',
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Image.asset(
              'images/name.png',
              scale: 12,
            ),
            title: TextField(
              controller: controller,
              onChanged: (String Value) async {
                name = Value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: SelectedName,
              ),
            ),
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
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.toString(),
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
              items: <String>['ECE', 'CSE', 'EEE']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                        color: Colors.grey, fontFamily: 'Staatliches'),
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
          Card(
            child: FlatButton(
                onPressed: () {
                  setState(() {
                    setSem(semester);
                    setBranch(branch);
                    setName(name);
                  });
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontFamily: 'Staatliches',
                      fontSize: 20),
                )),
          )
        ],
      ),
    );
  }

  Scaffold preferenceView() {
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
  }

  FlatButton buildSubject(int course, String image) {
    return FlatButton(
      onPressed: () {
        setState(() {
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
          '$SelectedSem/$image.png',
          scale: 15,
        ),
        title: Text(
          Courses[course],
          style: TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
        ),
      ),
    );
  }

  Scaffold PcycleHome() {
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
          style: TextStyle(color: Colors.indigo, fontFamily: 'Staatliches'),
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
          buildSubject(0, 'math'),
          buildSubject(1, 'math'),
          buildSubject(2, 'physics'),
          buildSubject(3, 'electrical'),
          buildSubject(4, 'civil'),
          buildSubject(5, 'mechanical'),
          buildSubject(6, 'workshop'),
          buildSubject(7, 'physicslab'),
          buildSubject(8, 'constitution'),
          buildSubject(9, 'kannada')
        ],
      ),
    );
  }

  Scaffold CcycleHome() {
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
                color: Colors.black,
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
          buildSubject(0, 'math'),
          buildSubject(1, 'math'),
          buildSubject(2, 'chemistry'),
          buildSubject(3, 'comp'),
          buildSubject(4, 'caed'),
          buildSubject(5, 'electronics'),
          buildSubject(6, 'chemlab'),
          buildSubject(7, 'environment'),
          buildSubject(8, 'english')
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
    if (SelectedSem == 'P-Cycle') {
      SelectedCourse = Pcycletopics;
      Courses = PcycleCourses;
      return bottomNavigate(PcycleHome());
    }
    if (SelectedSem == 'C-Cycle') {
      SelectedCourse = Ccycletopics;
      Courses = CcycleCourses;
      return bottomNavigate(CcycleHome());
    } else
      return preferenceView();
  }
}
