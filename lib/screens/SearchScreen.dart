import 'package:entangle/main.dart';
import 'package:flutter/material.dart';
import 'package:dartpedia/dartpedia.dart' as wiki;

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  @override
  Widget build(BuildContext context) {
    var result = '';
    void Query(String query) async {
      var wikipediaPage = await wiki.page('Dart (programming language)');
      setState(() {
        result = wikipediaPage.summary();
      });
      var relatedTopics = await wiki.search('California');
      print(relatedTopics);

      print(wikipediaPage);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: 'Search'),
              onChanged: (value) {
                Query(value);
              },
              onSubmitted: (value) {
                Query(value);
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Image.asset(
            'images/search.jpg',
            scale: 12,
          ),
          if (result == '') Text(result),
        ],
      ),
    );
  }
}
