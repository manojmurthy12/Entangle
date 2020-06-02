import 'package:flutter/material.dart';

class ResourceScreen extends StatefulWidget {
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  @override
  Widget build(BuildContext context) {
    ListTile buildModule(int module) {
      return ListTile(
        leading: Image.asset(
          'images/semester.png',
          scale: 13,
        ),
        title: Text(
          'Module -$module',
          style: TextStyle(color: Colors.black, fontFamily: 'Staatliches'),
        ),
      );
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.indigo),
            backgroundColor: Colors.white,
            title: Text(
              'Resources',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Staatliches', color: Colors.indigo),
            ),
            bottom: TabBar(
                indicatorWeight: 2,
                indicatorColor: Colors.indigo,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(
                      Icons.video_library,
                      color: Colors.indigo,
                    ),
                    child: Text(
                      'Videos',
                      style:
                          TextStyle(fontSize: 10, color: Colors.indigoAccent),
                    ),
                  ),
                  Tab(
                      child: Text(
                        'Files',
                        style:
                            TextStyle(fontSize: 10, color: Colors.indigoAccent),
                      ),
                      icon: Icon(
                        Icons.file_download,
                        color: Colors.indigo,
                      )),
                ]),
          ),
          body: TabBarView(children: <Widget>[
            ListView(
              children: [
                buildModule(1),
                buildModule(2),
                buildModule(3),
                buildModule(4),
                buildModule(5),
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
