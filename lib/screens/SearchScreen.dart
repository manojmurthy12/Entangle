import 'package:entangle/main.dart';
import 'package:flutter/material.dart';
import 'package:dartpedia/dartpedia.dart' as wiki;
import 'package:flutter/services.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:entangle/Services/API.dart';
import 'dart:convert';

var data;
String url;
String QueryText = 'Query';

class Search_screen extends StatefulWidget {
  @override
  _Search_screenState createState() => _Search_screenState();
}

class _Search_screenState extends State<Search_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(
            onSearch: search,
            onItemFound: (Post post, int index) {
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.description),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

Future<List<Post>> search(String search) async {
  await Future.delayed(Duration(seconds: 3));
  url = 'http://127.0.0.1:5000/api?Query=' + search;
  data = await Getdata(url);
  var DecodeData = jsonDecode(data);
  QueryText = DecodeData['Query'];

  return List.generate(1, (int index) {
    return Post(QueryText, 'It worked');
  });
}
