import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:entangle/Services/databaseHandling.dart';
import 'package:entangle/preferences.dart';
import 'package:entangle/tags/DocumentDictionary.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:entangle/main.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import 'package:percent_indicator/percent_indicator.dart';

int DocumentNumber;

List<String> Document_names = [];
String subject;
//String path;
String dir;
String pathPDF = "";
String title;

double downLoadProgress = 0;
Map temporary = {};

class Download_Screen extends StatefulWidget {
  final FirebaseStorage storage;

  const Download_Screen({Key key, this.storage}) : super(key: key);
  @override
  _Download_ScreenState createState() => _Download_ScreenState();
}

class _Download_ScreenState extends State<Download_Screen> {
  String path = '';
  String _downloadUrl;

  Future downloadUrl(String index) async {
    if (Documents[semester][subject].length > 0)
      path = semester + '/' + subject + '/' + index.split('_').last + '.pdf';
    StorageReference reference = FirebaseStorage.instance.ref().child(path);
    String downloadAddress = await reference.getDownloadURL();
    setState(() {
      _downloadUrl = downloadAddress;
    });
  }

  Future<File> createFileOfPdfUrl(int index) async {
    print(temporary);
    for (int i = 0; i < temporary.keys.length; i++) {
      if (temporary.values.toList()[i] == 0) {
        List path = temporary.keys.toList();
        await downloadUrl(path[i]);
        final url = _downloadUrl;
        String dir = (await getApplicationDocumentsDirectory()).path;
        String filepath = '$dir/' + path[i];
        File file;
        file = File(filepath);
        await Dio().download(url, filepath, onReceiveProgress: (rec, total) {
          setState(() {
            temporary[path[i]] = (rec / total) * 100;
          });
        }).whenComplete(() {
          setState(() {
            temporary.remove(path[i]);
            if (!Document_names.contains(path[i])) Document_names.add(path[i]);
            setSavedDocs(Document_names);
          });
          if (temporary.keys.toList().length >= 1)
            createFileOfPdfUrl(DocumentNumber);
          return file;
        });
      }
    }
  }

  Future<String> appDirectory() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  @override
  void initState() {
    super.initState();
    appDirectory().then((value) => dir = value);
    getSavedDocs().then((value) => Document_names = value);
  }

  void _showDialog(int index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            'Delete Permanently?',
            style: TextStyle(fontFamily: mainfont, fontSize: 15),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Yes", style: TextStyle(color: Colors.grey)),
              onPressed: () async {
                setState(() {
                  DocumentNumber = index;
                });
                try {
                  await File('$dir/' +
                          semester +
                          '_' +
                          subject +
                          '_' +
                          Documents[semester][subject][DocumentNumber])
                      .delete();
                  setState(() {
                    if (Document_names.contains(semester +
                        '_' +
                        subject +
                        '_' +
                        Documents[semester][subject][DocumentNumber]))
                      Document_names.remove(semester +
                          '_' +
                          subject +
                          '_' +
                          Documents[semester][subject][DocumentNumber]);
                    setSavedDocs(Document_names);
                    downLoadProgress = 0;
                    print('file deleted');
                    Navigator.of(context).pop();
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
            FlatButton(
                color: maincolor2,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        );
      },
    );
  }

  FlatButton buildDowloadTabs(int index) {
    return FlatButton(
      onPressed: () async {
        setState(() {
          DocumentNumber = index;
        });
        if (await File('$dir/' +
                    semester +
                    '_' +
                    subject +
                    '_' +
                    Documents[semester][subject][DocumentNumber])
                .exists() ==
            true) {
          pathPDF = '$dir/' +
              semester +
              '_' +
              subject +
              '_' +
              Documents[semester][subject][DocumentNumber];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(pathPDF),
            ),
          );
        } else {
          setState(() {
            DocumentNumber = index;
            temporary[semester +
                '_' +
                subject +
                '_' +
                Documents[semester][subject][DocumentNumber]] = 0;
          });
          if (temporary.keys.toList().length == 1)
            await createFileOfPdfUrl(DocumentNumber).then((f) {
              setState(() {
                pathPDF = f.path;
                print(pathPDF);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFScreen(pathPDF),
                  ),
                );
              });
            });
        }
      },
      child: ListTile(
        leading: Icon(
          Icons.insert_drive_file,
          color: maincolor2,
        ),
        title: Text(
          Documents[semester][subject][index],
          style: TextStyle(fontSize: 13, fontFamily: mainfont),
        ),
        trailing: buildIcons(index),
      ),
    );
  }

  Container buildIcons(int index) {
    getSavedDocs().then((value) => Document_names = value);
    if (temporary.keys.contains(semester +
            '_' +
            subject +
            '_' +
            Documents[semester][subject][index]) &&
        downLoadProgress != null) {
      List progress = temporary.values.toList();
      return Container(
          child: SizedBox(
        child: CircularPercentIndicator(
          radius: 45,
          percent: double.parse((temporary[semester +
                      '_' +
                      subject +
                      '_' +
                      Documents[semester][subject][index]] /
                  100)
              .toStringAsFixed(1)),
          progressColor: maincolor,
          lineWidth: 5,
          center: Text((temporary[semester +
                      '_' +
                      subject +
                      '_' +
                      Documents[semester][subject][index]])
                  .floor()
                  .toString() +
              '%'),
        ),
      ));
    }
    if (Document_names.contains(
        semester + '_' + subject + '_' + Documents[semester][subject][index]))
      return Container(
        child: IconButton(
          onPressed: () async {
            setState(() {
              DocumentNumber = index;
            });
            _showDialog(DocumentNumber);
          },
          icon: Icon(
            Icons.delete_forever,
            color: maincolor2,
          ),
        ),
      );
    if (!Document_names.contains(
        semester + '_' + subject + '_' + Documents[semester][subject][index]))
      return Container(
        child: IconButton(
          onPressed: () {
            setState(() {
              DocumentNumber = index;
              temporary[semester +
                  '_' +
                  subject +
                  '_' +
                  Documents[semester][subject][DocumentNumber]] = 0;
            });
            if (temporary.keys.toList().length == 1) {
              try {
                createFileOfPdfUrl(DocumentNumber).then((f) {
                  setState(() {
                    pathPDF = f.path;
                    if (!Document_names.contains(semester +
                        '_' +
                        subject +
                        '_' +
                        Documents[semester][subject][DocumentNumber]))
                      Document_names.add(semester +
                          '_' +
                          subject +
                          '_' +
                          Documents[semester][subject][DocumentNumber]);
                    setSavedDocs(Document_names);
                    print(pathPDF);
                    //downLoadProgress = 1;
                  });
                });
              } catch (e) {
                print(e);
              }
            }
          },
          icon: Icon(
            Icons.file_download,
            color: maincolor2,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    getSavedDocs().then((value) => Document_names = value);
    if (Documents[semester][subject].length > 0) {
      return Scaffold(
        body: ListView(
          children: [
            for (int i = 0; i < Documents[semester][subject].length; i++)
              buildDowloadTabs(i),
            /*SizedBox(
              height: (MediaQuery.of(context).size.height),
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return buildDowloadTabs(index);
                  },
                  itemCount: Documents[semester][subject].length),
            ),*/
          ],
        ),
      );
    } else
      return nothingtoshow2();
  }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    print(pathPDF);
    String title =
        pathPDF.split('/')[pathPDF.split('/').length - 1].split('_')[2];
    return PDFViewerScaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [maincolor2, maincolor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(
                    '$title.pdf\nYou can download all your Engineering resources at Entangle\nhttps://play.google.com/store/apps/dev?id=4633135606490362370');
              },
            ),
          ],
        ),
        path: pathPDF);
  }
}
