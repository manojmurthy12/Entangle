import 'dart:core';

import 'package:entangle/main.dart';
import 'package:entangle/tags/CourseDictionary.dart';
import 'package:entangle/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:dartpedia/dartpedia.dart' as wiki;
import 'package:flutter/services.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:entangle/Services/API.dart';
import 'dart:convert';

var data;

String url;

class DataSearch extends SearchDelegate<String> {
  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Search';
  @override
  // TODO: implement searchFieldStyle
  TextStyle get searchFieldStyle => TextStyle(color: Colors.grey);
  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return ThemeData(
      appBarTheme: AppBarTheme(),
      primaryColor: Colors.white,
      primaryColorBrightness: Brightness.light,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: maincolor,
          ),
          onPressed: () => query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
          color: maincolor,
        ),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      height: 230,
      child: Scrollbar(
        controller:
            ScrollController(keepScrollOffset: true, debugLabel: 'true'),
        isAlwaysShown: true,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          Container(
            width: (MediaQuery.of(context).size.width),
            child: FutureBuilder<String>(
                future: getDictionary(query),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      // color: Colors.white60,
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                                title: Text(
                                  'Dictionary',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: maincolor),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward,
                                  color: maincolor2,
                                )),
                            if (snapshot.data == 'No results found')
                              Expanded(
                                  child: ListTile(
                                leading: Icon(Icons.error),
                                title: Text('No results found'),
                              )),
                            if (snapshot.data != 'No results found')
                              Expanded(
                                child: ListView(children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      query,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      snapshot.data,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    padding: EdgeInsets.all(15),
                                  ),
                                ]),
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: maincolor2,
                  ));
                }),
          ),
          Container(
            width: (MediaQuery.of(context).size.width),
            child: FutureBuilder<String>(
                future: buildWikipedia(query),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      // color: Colors.white60,
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'Wikipedia',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: maincolor),
                              ),
                            ),
                            if (snapshot.data == 'No results found')
                              Expanded(
                                  child: ListTile(
                                leading: Icon(Icons.error),
                                title: Text('No results found'),
                              )),
                            if (snapshot.data != 'No results found')
                              Expanded(
                                child: ListView(children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      query,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      snapshot.data,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    padding: EdgeInsets.all(15),
                                  ),
                                ]),
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: maincolor2,
                  ));
                }),
          ),
        ]),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List>(
        future: getSuggestions(query),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemBuilder: (context, index) => FlatButton(
                onPressed: () {
                  query = snapshot.data[index];
                  buildResults(context);
                },
                child: ListTile(
                  leading: Icon(Icons.subdirectory_arrow_right),
                  title: Text(snapshot.data[index]),
                ),
              ),
              itemCount: snapshot.data.length - 5,
            );
          }
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: maincolor2,
          ));
        });
    //show when someone searches for something
  }

  Future<String> buildWikipedia(String Query) async {
    var Result;
    try {
      url = 'https://manojmurthy.pythonanywhere.com/api?Query=' + Query;
      data = await Getdata(url);
      var DecodeData = jsonDecode(data);
      Result = DecodeData['Query'].toString();
      print(Result);
    } catch (e) {
      Result = 'No results found';
      print(e);
    }
    return Result;
  }

  Future<List> getSuggestions(String Query) async {
    List SuggestionList = [];
    try {
      url = 'https://manojmurthy.pythonanywhere.com/suggestions?Query=' + Query;
      data = await Getdata(url);
      var DecodeData = jsonDecode(data);
      print(DecodeData);
      SuggestionList = DecodeData;

      //print(SuggestionList);
    } catch (e) {
      SuggestionList = null;
      print(e);
    }
    return SuggestionList;
  }

  Future<String> getDictionary(String Query) async {
    String Result;
    try {
      data =
          await GetDictionary('https://owlbot.info/api/v4/dictionary/' + Query);
      var DecodeData = jsonDecode(data);
      Result = DecodeData["definitions"][0]["definition"].toString();
    } catch (e) {
      Result = 'No results found';
      print(e);
    }
    return Result;
  }
}
