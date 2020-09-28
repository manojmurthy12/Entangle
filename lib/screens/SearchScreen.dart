import 'dart:core';
import 'package:dio/dio.dart';
import 'package:entangle/main.dart';
import 'package:entangle/preferences.dart';
import 'package:entangle/screens/Video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:entangle/Services/API.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';

var data;

String url;
List<String> SearchHistory = [];
String gifURL = null;

class DataSearch extends SearchDelegate<String> {
  final PageController _pageController = PageController();
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
          icon: (query != '')
              ? Icon(
                  Icons.clear,
                  color: maincolor,
                )
              : Icon(
                  Icons.search,
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
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    if (SearchHistory != null) {
      if (!SearchHistory.contains(query.toLowerCase()) &&
          query != '' &&
          query != null) {
        if (SearchHistory.length > 10) {
          SearchHistory.removeAt(SearchHistory.length - 1);
          SearchHistory.insert(0, query.toLowerCase());
        } else
          SearchHistory.insert(0, query.toLowerCase());
      }
    } else {
      if (query != '' && query != null) SearchHistory.add(query.toLowerCase());
    }

    setSearchHistory(SearchHistory);
    //buildYoutubeResults(query);
    return ListView(children: [
      Container(
        height: 220,
        child: Scrollbar(
          thickness: 5,
          controller: _pageController,
          isAlwaysShown: true,
          child: PageView(
              physics: ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width),
                  child: FutureBuilder<Map>(
                      future: buildWikipedia(query),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                      title: Row(children: [
                                        Text(
                                          'Wikipedia',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: maincolor),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.open_in_new,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            _launchURL(snapshot.data['url']);
                                          },
                                        )
                                      ]),
                                      trailing: Icon(
                                        Icons.done_all,
                                        color: Colors.green,
                                      )),
                                  if (snapshot.data['error'] ==
                                      'No results found')
                                    Expanded(
                                        child: ListTile(
                                      leading: Icon(Icons.error),
                                      title: Text('No results found'),
                                    )),
                                  if (snapshot.data['error'] !=
                                      'No results found')
                                    Expanded(
                                      child: ListView(children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Text(
                                            snapshot.data['title'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            snapshot.data['summary'],
                                            style: TextStyle(
                                                color: Colors.grey[600]),
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
                            child: Image.asset(
                          'images/loading.gif',
                          scale: 3,
                        ));
                      }),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  child: FutureBuilder<String>(
                      future: getDictionary(query),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                        Icons.done_all,
                                        color: Colors.green,
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
                                            style: TextStyle(
                                                color: Colors.grey[600]),
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
                            child: Image.asset(
                          'images/loading.gif',
                          scale: 5,
                        ));
                      }),
                ),
              ]),
        ),
      ),
      /*Container(
        child: FutureBuilder<List>(
            future: buildYoutubeResults(query),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                FlatButton buildVideo(int index) {
                  return FlatButton(
                    onPressed: () {
                      VideoUrl = snapshot.data[index]['url'];
                      VideoTitle = snapshot.data[index]['title'];
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
                        snapshot.data[index]['title'],
                        style: TextStyle(fontSize: 13, fontFamily: mainfont),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.bookmark,
                            color: maincolor2,
                          ),
                          onPressed: () {}),
                    ),
                  );
                }

                print(snapshot.data);

                return Column(
                  children: [
                    for (int i = 0; i < snapshot.data.toList().length; i++)
                      buildVideo(i)
                  ],
                );
              }
              return Center(
                  child: Image.asset(
                'images/loading.gif',
                scale: 5,
              ));
            }),
      )*/
    ]);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    getSearchHistory().then((value) => SearchHistory = value);
    //print(SearchHistory);
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List>(
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
                    itemCount:
                        (snapshot.data.length > 10) ? 10 : snapshot.data.length,
                  );
                }
                return Center(
                    child: Image.asset(
                  'images/loading.gif',
                  scale: 4,
                ));
              }),
        ),
      ],
    );
    //show when someone searches for something
  }

  Future<Map> buildWikipedia(String Query) async {
    Map Result = {};
    //print(wiki);
    //print(wiki['pages'][0]['excerpt']);
    try {
      url = 'https://entanglebackend.herokuapp.com/summary?query=' + Query;
      data = await Getdata(url);
      var DecodeData = jsonDecode(data);
      //print(DecodeData);
      Result = DecodeData;
      if (!Query.toLowerCase()
          .contains(Result['title'].toString().toLowerCase())) {
        print(Result['title']);
        Result['error'] = 'No results found';
      }
      //print(Result);
    } catch (e) {
      Result['error'] = 'No results found';
      print(e);
    }
    /*Result['title'] = wiki['pages'][0]['title'].toString();
    Result['description'] = wiki['pages'][0]['description'].toString() +
        ', ' +
        wiki['pages'][0]['excerpt'].toString().replaceAll(RegExp('<.*?>'), '');*/
    return Result;
  }

  Future<List> buildYoutubeResults(String Query) async {
    var Result = [];
    url = 'https://entanglebackend.herokuapp.com/suggest?query=' + Query;
    data = await Getdata(url);
    var DecodeData = jsonDecode(data);
    //print(DecodeData);
    Result = DecodeData;
    return Result;
  }

  Future<List> getSuggestions(String Query) async {
    final Xml2Json xml2Json = Xml2Json();
    List SuggestionList = [];
    if (Query == null || Query == '') return SearchHistory;
    xml2Json.parse(await Getdata(
        'https://www.google.com/complete/search?output=toolbar&q=$Query&hl=en'));
    var jsonString = xml2Json.toGData();
    var data = jsonDecode(jsonString);
    //print(data);
    for (int i = 0; i < data['toplevel']['CompleteSuggestion'].length; i++)
      SuggestionList.add(
          data['toplevel']['CompleteSuggestion'][i]['suggestion']['data']);
    print(SuggestionList);
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
