import 'dart:convert';

import 'package:http/http.dart' as http;

String _token = "7143bb214978253bff85a9bb3fca6194ffa6820d";
String Dicturl = "https://owlbot.info/api/v4/dictionary/";

Future Getdata(url) async {
  http.Response Response = await http.get(url);
  return Response.body;
}

Future GetDictionary(url) async {
  http.Response Response =
      await http.get(url, headers: {"Authorization": "Token " + _token});
  return Response.body;
}

Future GetWiki(url) async {
  http.Response response = await http.get(url);
  var result = jsonDecode(response.body);
  print(result);
}
