import 'package:entangle/screens/Downloads.dart';
import 'package:entangle/screens/OnboardingScreen.dart';
import 'package:entangle/screens/SearchScreen.dart';
import 'package:entangle/screens/login_screen.dart';
import 'package:entangle/tags/VideoDictionary.dart';
import 'package:entangle/tags/CourseDictionary.dart';
import 'package:entangle/tags/modules.dart';
import 'package:entangle/utilities/AuthCredentials.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/home.dart';
import 'preferences.dart';
import 'screens/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';
import 'package:connectivity/connectivity.dart';

bool persistence;
String userEmail, userPassword;
var connectivityResult;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  final FirebaseStorage storage = FirebaseStorage(
      app: app, storageBucket: 'gs://flutter-firebase-plugins.appspot.com');
  getEmail().then((value) => userEmail = value);
  getPassword().then((value) => userPassword = value);
  getSem().then((value) => semester = value);
  getBranch().then((value) => branch = value);
  await assignValues(VideoDictionary[semester]);
  if (userEmail != null &&
      userPassword != null &&
      userEmail != '' &&
      userPassword != '') SignIn(userEmail, userPassword);

  runApp(
    MaterialApp(home: await getLandingPage()),
  );
}

String usertitle = 'Your Email';
bool logged_in = false;
Future<Widget> getLandingPage() async {
  connectivityResult = await (Connectivity().checkConnectivity());

  return StreamBuilder<User>(
    stream: auth.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.hasData && !snapshot.data.isAnonymous) {
        if (auth.currentUser.email != null) {
          print(auth.currentUser.email);
          usertitle = auth.currentUser.email;
          print(usertitle);
        }

        return FirstScreen();
      } else {
        return OnboardingScreen();
        print("error"); //Connection Inactive, show error dialog
      }
    },
  );
}

Future<void> SignIn(String Email, String Password) async {
  try {
    Firebase.initializeApp();
    print(Email);
    UserCredential user =
        await auth.signInWithEmailAndPassword(email: Email, password: Password);
  }
  //_message = 'Logging in';
  catch (e) {
    print(e);
  }
}

Color maincolor = Color.fromRGBO(113, 170, 239, 1);
Color maincolor2 = Color.fromRGBO(209, 144, 226, 1);
String mainfont = 'OpenSans';
String SelectedName = '';
String SelectedSem =
    ''; // this variable will be used to store the present status of the branch and Semester
String SelectedBranch = '';
List imageTag = [];
String CourseImage = '';
String VideoUrl;
String VideoTitle;
List<String> UpnextVideos;

TextEditingController controller;

int SubjectNumber = 0;
int TopicNumber = 0;
int SubtopicNumber = 0;
int VideoNumber = 0;
String name = 'College name';
String semester = 'P-Cycle';
String branch = 'ECE';
String phoneNumber;
String contactText;
bool fromSave = true;

List Courses = [];

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
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    getEmail().then((value) => userEmail = value);
    getPassword().then((value) => userPassword = value);
    getSavedDocs().then((value) => Document_names = value);
    appDirectory().then((value) => dir = value);
    getSem().then((value) async {
      semester = value;
      await assignValues(VideoDictionary[semester]);
    });
    getBranch().then((value) => branch = value);
    Firebase.initializeApp().whenComplete(() {});
  }

  Future<String> appDirectory() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  Drawer setting() {
    return Drawer(child: preference());
  }

  Container preference() {
    return Container(
      color: maincolor,
      child: ListView(
        children: [
          Container(
            height: 280,
            color: Colors.white,
            child: Image.asset(
              'images/setting.jpg',
              scale: 6,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [maincolor, Colors.white],
                    end: Alignment.topCenter,
                    begin: Alignment.bottomCenter)),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    backgroundColor: maincolor2,
                  ),
                  title: Text(
                    (usertitle != null) ? usertitle : 'Your Name',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  //subtitle: Text(_auth.currentUser.email),
                ),
                Container(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    color: Colors.grey[100],
                    child: const Text(
                      'Sign out',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    onPressed: () {
                      handleSignOut().whenComplete(
                          () => Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              )));
                    },
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
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: DropdownButton<String>(
                    value: (semester == 'P-Cycle') ? 'Sem-1' : 'Sem-2',
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    items: <String>[
                      'Sem-1',
                      'Sem-2',
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
                        if (newValue == 'Sem-1') semester = 'P-Cycle';
                        if (newValue == 'Sem-2') semester = 'C-Cycle';
                        setSem(semester);
                        print(semester);
                        assignValues(VideoDictionary[semester]);
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
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
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
                        setBranch(branch);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 60,
                ),
                FlatButton.icon(
                  onPressed: () {
                    Share.share(
                        'https://play.google.com/store/apps/dev?id=4633135606490362370'); //TODO: Change the app id
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
    return Scaffold(
      body: preference(),
    );
  }

  FlatButton buildSubject(int course, String image) {
    return FlatButton(
      onPressed: () {
        setState(() {
          CourseImage = image;
          SubjectNumber = course;
          subject = Courses[course];
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResourceScreen(),
          ),
        );
      },
      child: Container(
        child: ListTile(
          leading: Image.asset(
            'courseImages/$image.png',
            scale: 15,
          ),
          title: Text(
            Courses[course],
            style: TextStyle(
                color: Colors.grey[800],
                fontFamily: mainfont,
                fontSize: 13,
                fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }

  WillPopScope Home(List image) {
    imageTag = image;
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        backgroundColor: Colors.white,
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
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () => showSearch(
                      context: context,
                      delegate: DataSearch(),
                    ))
          ],
          backgroundColor: maincolor,
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                child: Column(
                  children: [
                    Image.asset(
                      'images/MainBanner.jpg',
                      scale: 1,
                    ),
                  ],
                ),
              ),
              for (int index = 0; index < image.length; index++)
                buildSubject(index, imageTag[index]),
              Container(
                width: double.infinity,
                height: 40,
                child: Center(
                  child: Text(
                    'missing subjects are in the other semester',
                    style: TextStyle(
                        color: Colors.grey, fontFamily: mainfont, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
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
    if (SelectedSem == 'P-Cycle') {
      SelectedCourse = Pcycletopics;
      Courses = PcycleDict.keys.toList();
      return bottomNavigate(Home(PcycleDict.values.toList()), context);
    }
    if (SelectedSem == 'C-Cycle') {
      SelectedCourse = Ccycletopics;
      Courses = CcycleDict.keys.toList();
      return bottomNavigate(Home(CcycleDict.values.toList()), context);
    } else
      return preferenceView();
  }
}

Future<bool> assignValues(List<List<List<Map>>> getList) async {
  SelectedCourseVideo = [];
  SelectedCourseVideolinks = [];
  try {
    for (int i = 0; i < getList.length; i++) {
      SelectedCourseVideolinks.add([]);
      SelectedCourseVideo.add([]);
      for (int j = 0; j < getList[i].length; j++) {
        SelectedCourseVideolinks[i].add([]);
        SelectedCourseVideo[i].add([]);
        for (int k = 0; k < getList[i][j].length; k++) {
          var temp = getList[i][j][k].keys.toList();
          var temp2 = getList[i][j][k].values.toList();
          SelectedCourseVideolinks[i][j].add(temp);
          SelectedCourseVideo[i][j].add(temp2);
        }
      }
    }
    return Future.value(true);
  } catch (e) {
    print(e.message);
    return Future.value(false);
  }
}
