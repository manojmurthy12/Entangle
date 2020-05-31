import 'package:flutter/material.dart';
import 'screens/splashscreen.dart';
import 'screens/home.dart';
import 'screens/preferences.dart';

void main() {
  runApp(MaterialApp(home: Splash()));
}

String SelectedName = '';
String SelectedSem =
    ''; // this variable will be used to store the present status of the branch and Semester
String SelectedBranch = '';
TextEditingController controller;

String semester = 'P-Cycle';
String branch = 'ECE';
String name = '';

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
            'images/course.jpg',
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
              scale: 12,
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
              scale: 12,
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
                      color: Colors.black,
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
        backgroundColor: Colors.blue[300],
        title: Text(
          'Select your Preferences',
          style: TextStyle(color: Colors.white, fontFamily: 'Bebas Neue'),
        ),
      ),
      body: preference(),
    );
  }

  Scaffold PcycleHome() {
    ListTile buildSubject(String name, String image) {
      return ListTile(
        leading: Image.asset(
          'p-cycle/$image.png',
          scale: 15,
        ),
        title: Text(
          name,
          style: TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
        ),
      );
    }

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
          buildSubject('Mathematics-1', 'math'),
          buildSubject('Mathematics-2', 'math'),
          buildSubject('Physics', 'physics'),
          buildSubject('Basic Electrical Engg', 'electrical'),
          buildSubject('Elements of Civil Engineering and Mechanics', 'civil'),
          buildSubject('Elements of Mechanical Engg', 'mechanical'),
          buildSubject('Workshop Practice', 'workshop'),
          buildSubject('Physics Lab', 'physicslab'),
          buildSubject(
              'Constitution of India and Professional Ethics', 'constitution'),
          buildSubject('Kannada', 'kannada')
        ],
      ),
    );
  }

  Scaffold CcycleHome() {
    ListTile buildSubject(String name, String image) {
      return ListTile(
        leading: Image.asset(
          'c-cycle/$image.png',
          scale: 15,
        ),
        title: Text(
          name,
          style: TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
        ),
      );
    }

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
          buildSubject('Mathematics-1', 'math'),
          buildSubject('Mathematics-2', 'math'),
          buildSubject('Chemistry', 'chemistry'),
          buildSubject('Programming in C and Data Structures', 'comp'),
          buildSubject('Computer aided engineering Drawing', 'caed'),
          buildSubject('Basic Electronics', 'electronics'),
          buildSubject('Chemistry Lab', 'chemlab'),
          buildSubject('Environmental Studies ', 'environment'),
          buildSubject('English Language', 'english')
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
    if (SelectedSem == 'P-Cycle') return bottomNavigate(PcycleHome());
    if (SelectedSem == 'C-Cycle')
      return bottomNavigate(CcycleHome());
    else
      return preferenceView();
  }
}
