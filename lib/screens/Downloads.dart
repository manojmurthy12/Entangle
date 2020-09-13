import 'package:entangle/tags/DocumentDictionary.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:entangle/main.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_plugin.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

List<String> Document_names;
String subject;
//String path;
var filename;
String dir;
String pathPDF = "";
String title;

int downLoadProgress;

class Download_Screen extends StatefulWidget {
  final FirebaseStorage storage;

  const Download_Screen({Key key, this.storage}) : super(key: key);
  @override
  _Download_ScreenState createState() => _Download_ScreenState();
}

class _Download_ScreenState extends State<Download_Screen> {
  String path = '';
  String _downloadUrl;
  String _DownloadErrorMessage;

  Future downloadFile(int index) async {
    if (Documents[semester][subject].length > 0)
      path = semester +
          '/' +
          subject +
          '/' +
          Documents[semester][subject][index] +
          '.pdf';
    StorageReference reference = FirebaseStorage.instance.ref().child(path);
    String downloadAddress = await reference.getDownloadURL();
    setState(() {
      _downloadUrl = downloadAddress;
    });
  }

  Future<File> createFileOfPdfUrl(int index) async {
    await downloadFile(index);
    final url = _downloadUrl;
    File file;
    filename = Documents[semester][subject][index];
    setState(() {
      downLoadProgress = 2;
    });
    String dir = (await getApplicationDocumentsDirectory()).path;
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    print(filename);
    file = File('$dir/$filename');
    await file.writeAsBytes(bytes).whenComplete(() => downLoadProgress = 0);
    return file;
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            _DownloadErrorMessage,
            style: TextStyle(fontFamily: mainfont, fontSize: 15),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> appDirectory() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  @override
  void initState() {
    super.initState();
    appDirectory().then((value) => dir = value);
    if (Documents[semester][subject].length > 0)
      path = semester.toString() +
          '/' +
          subject +
          '/' +
          Documents[semester][subject][0].toString() +
          ".pdf";
    else
      path = 'physics';
    checkFileexistence(0);
  }

  Future<bool> checkFileexistence(int index) async {
    filename = Documents[semester][subject][index];
    print(filename);
    try {
      await File('$dir/$filename').exists().then((value) {
        setState(() {
          if (value == true) {
            downLoadProgress = 1;
            print('present');
          } else {
            print('notPresent');
            downLoadProgress = 0;
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    print(Documents[semester][subject]);
    if (Documents[semester][subject].length > 0) {
      title = Documents[semester][subject][0];
      return Scaffold(
        body: ListView(
          children: [
            FlatButton(
              onPressed: () async {
                filename = Documents[semester][subject][index];
                if (await File('$dir/$filename').exists() == true) {
                  pathPDF = '$dir/$filename';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFScreen(pathPDF),
                    ),
                  );
                } else
                  createFileOfPdfUrl(index).then((f) {
                    setState(() {
                      pathPDF = f.path;
                      print(pathPDF);

                      downLoadProgress = 1;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(pathPDF),
                        ),
                      );
                    });
                  });
              },
              child: ListTile(
                leading: Icon(
                  Icons.insert_drive_file,
                  color: maincolor2,
                ),
                title: Text(title),
                trailing: (downLoadProgress == 1)
                    ? IconButton(
                        onPressed: () async {
                          filename = Documents[semester][subject][index];
                          try {
                            await File('$dir/$filename').delete();
                            setState(() {
                              downLoadProgress = 0;
                              print('file deleted');
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          color: maincolor2,
                        ),
                      )
                    : (downLoadProgress == 0)
                        ? IconButton(
                            onPressed: () async {
                              try {
                                createFileOfPdfUrl(index).then((f) {
                                  setState(() {
                                    pathPDF = f.path;
                                    print(pathPDF);
                                    downLoadProgress = 1;
                                  });
                                });
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(
                              Icons.file_download,
                              color: maincolor2,
                            ),
                          )
                        : Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              backgroundColor: maincolor2,
                            ),
                          ),
              ),
            )
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
    return PDFViewerScaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [maincolor2, maincolor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }
}
