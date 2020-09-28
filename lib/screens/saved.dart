import 'dart:io';

import 'package:entangle/Services/API.dart';
import 'package:entangle/screens/Downloads.dart';
import 'package:entangle/tags/DocumentDictionary.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:entangle/main.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'Video_player.dart';
import 'package:entangle/preferences.dart';

var filename;
WillPopScope save(BuildContext context) {
  getSavedVideo().then((value) {
    SavedVideo = value;
  });
  getSavedLink().then((value) {
    SavedLink = value;
  });
  getSavedDocs().then((value) => Document_names = value);
  //print(Document_names);
  Column buildVideo() {
    if (SavedVideo.length <= 3)
      return Column(
        children: [
          ListTile(
            title: Text(
              'Videos',
              style: TextStyle(fontFamily: mainfont),
            ),
          ),
          for (int video = 0; video < SavedVideo.length; video++)
            FlatButton(
              onPressed: () {
                VideoNumber = video;
                print(VideoNumber);
                VideoUrl = SavedLink[VideoNumber];
                VideoTitle = SavedVideo[VideoNumber];
                print(VideoUrl);
                print(VideoTitle);
                fromSave = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => player(),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(
                  Icons.play_circle_filled,
                  color: maincolor,
                ),
                title: Text(
                  SavedVideo[video],
                  style: TextStyle(fontSize: 13, fontFamily: mainfont),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: maincolor,
                    ),
                    onPressed: () {
                      SavedVideo.remove(SavedVideo[video]);
                      SavedLink.remove(SavedLink[video]);
                      setSavedVideo(SavedVideo);
                      setSavedLink(SavedLink);
                    }),
              ),
            ),
          Divider(
            color: Colors.grey[200],
          )
        ],
      );
    else
      return Column(
        children: [
          ListTile(
            title: Text(
              'Videos',
              style: TextStyle(fontFamily: mainfont),
            ),
          ),
          for (int video = 0; video < 3; video++)
            FlatButton(
              onPressed: () {
                VideoNumber = video;
                print(VideoNumber);
                VideoUrl = SavedLink[VideoNumber];
                VideoTitle = SavedVideo[VideoNumber];
                print(VideoUrl);
                print(VideoTitle);
                fromSave = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => player(),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(
                  Icons.play_circle_filled,
                  color: maincolor,
                ),
                title: Text(
                  SavedVideo[video],
                  style: TextStyle(fontSize: 13, fontFamily: mainfont),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: maincolor,
                    ),
                    onPressed: () {
                      SavedVideo.remove(SavedVideo[video]);
                      SavedLink.remove(SavedLink[video]);
                      setSavedVideo(SavedVideo);
                      setSavedLink(SavedLink);
                    }),
              ),
            ),
          ExpandChild(
            child: Column(
              children: [
                for (int video = 3; video < SavedVideo.length; video++)
                  FlatButton(
                    onPressed: () {
                      VideoNumber = video;
                      print(VideoNumber);
                      VideoUrl = SavedLink[VideoNumber];
                      VideoTitle = SavedVideo[VideoNumber];
                      print(VideoUrl);
                      print(VideoTitle);
                      fromSave = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => player(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.play_circle_filled,
                        color: maincolor,
                      ),
                      title: Text(
                        SavedVideo[video],
                        style: TextStyle(fontSize: 13, fontFamily: mainfont),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: maincolor,
                          ),
                          onPressed: () {
                            SavedVideo.remove(SavedVideo[video]);
                            SavedLink.remove(SavedLink[video]);
                            setSavedVideo(SavedVideo);
                            setSavedLink(SavedLink);
                          }),
                    ),
                  ),
              ],
            ),
          )
        ],
      );
  }

  Column buildDocs() {
    FlatButton buildDownloadTabs(int index) {
      return FlatButton(
        onPressed: () async {
          filename = Document_names[index];
          if (await File('$dir/$filename').exists() == true) {
            pathPDF = '$dir/$filename';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFScreen(pathPDF),
              ),
            );
          }
        },
        child: ListTile(
          leading: Icon(
            Icons.insert_drive_file,
            color: maincolor2,
          ),
          title: Text(
            Document_names[index].split('_')[2],
            style: TextStyle(fontSize: 13, fontFamily: mainfont),
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: maincolor2,
              ),
              onPressed: () async {
                filename = Document_names[index];
                try {
                  await File('$dir/$filename').delete();
                  if (Document_names.contains(filename))
                    Document_names.remove(filename);
                  setSavedDocs(Document_names);
                  print('file deleted');
                } catch (e) {
                  print(e);
                }
              }),
          subtitle: Text(
              (Document_names[index].split('_')[0] == 'P-Cycle')
                  ? 'Sem-1'
                  : (Document_names[index].split('_')[0] == 'C-Cycle')
                      ? 'Sem-2'
                      : (Document_names[index].split('_')[0]),
              style: TextStyle(fontSize: 12, fontFamily: mainfont)),
        ),
      );
    }

    if (Document_names.length <= 3)
      return Column(
        children: [
          ListTile(
            title: Text(
              'Files',
              style: TextStyle(fontFamily: mainfont),
            ),
          ),
          for (int i = 0; i < Document_names.length; i++) buildDownloadTabs(i),
        ],
      );
    else
      return Column(
        children: [
          ListTile(
            title: Text(
              'Files',
              style: TextStyle(fontFamily: mainfont),
            ),
          ),
          for (int i = 0; i < 3; i++) buildDownloadTabs(i),
          ExpandChild(
              child: Column(
            children: [
              for (int i = 3; i < Document_names.length; i++)
                buildDownloadTabs(i)
            ],
          ))
        ],
      );
  }

  return WillPopScope(
    onWillPop: () => SystemNavigator.pop(),
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: maincolor,
        title: Text(
          'Saved',
          style: TextStyle(fontFamily: mainfont),
        ),
      ),
      body: ListView(
        children: [
          if (SavedVideo.length != 0 || Document_names.length != 0)
            Column(
              children: [
                if (SavedVideo.length != 0) buildVideo(),
                if (Document_names.length != 0) buildDocs()
              ],
            )
          else
            nothingtoshow2()
        ],
      ),
    ),
  );
}
