import 'package:flutter/material.dart';

class ResourceScreen extends StatefulWidget {
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigoAccent,
            title: Text(
              'Resources',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Staatliches',
              ),
            ),
            bottom: TabBar(
                indicatorWeight: 2,
                indicatorColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    child: Icon(
                      Icons.video_library,
                      color: Colors.white,
                    ),
                  ),
                  Tab(
                      child: Icon(
                    Icons.file_download,
                    color: Colors.indigo,
                  )),
                ]),
          ),
          body: TabBarView(children: <Widget>[
            ListView(
              children: [
                Image.asset('images/videos.jpg'),
                Center(
                  child: Text(
                    'Nothing to show yet.',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
                  ),
                )
              ],
            ),
            ListView(
              children: [
                Image.asset('images/files.jpg'),
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
