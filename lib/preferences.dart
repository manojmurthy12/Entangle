import 'package:entangle/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getName() async {
  final prefs = await SharedPreferences.getInstance();
  final _nameSelect = prefs.getString('Name');
  if (_nameSelect == null || _nameSelect == '')
    return SelectedName;
  else
    return _nameSelect;
}

Future<String> getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  final _emailSelect = prefs.getString('email');
  if (_emailSelect == null || _emailSelect == '')
    return null;
  else
    return _emailSelect;
}

Future<void> setEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  print(email);
}

Future<String> getPassword() async {
  final prefs = await SharedPreferences.getInstance();
  final _passwordSelect = prefs.getString('password');
  if (_passwordSelect == null || _passwordSelect == '')
    return null;
  else
    return _passwordSelect;
}

Future<void> setPassword(String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('password', password);
}

Future<void> setName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('Name', name);
}

Future<String> getSem() async {
  final prefs = await SharedPreferences.getInstance();
  final _semSelect = prefs.getString('Sem');
  if (_semSelect == null)
    return 'P-Cycle';
  else
    return _semSelect;
} //it will access device storage and returns the current semester

Future<void> setSem(String sem) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('Sem', sem);
} //it will take string as parameter and stores that string as semester in the device

Future<String> getBranch() async {
  final prefs = await SharedPreferences.getInstance();
  final _branchSelect = prefs.getString('Branch');
  if (_branchSelect == null)
    return 'ECE';
  else
    return _branchSelect;
} //it will access device storage and returns the current branch

Future<void> setBranch(String branch) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('Branch', branch);
}

Future<List<String>> getSavedVideo() async {
  final prefs = await SharedPreferences.getInstance();
  final _Saved = prefs.getStringList('savevideo');
  if (_Saved == null)
    return SavedVideo;
  else
    return _Saved;
} //it will access device storage and returns the current branch

Future<void> setSavedVideo(List<String> saved) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('savevideo', saved);
}

Future<List<String>> getSavedLink() async {
  final prefs = await SharedPreferences.getInstance();
  final _Savedlink = prefs.getStringList('savelink');
  if (_Savedlink == null)
    return SavedLink;
  else
    return _Savedlink;
} //it will access device storage and returns the current branch

Future<void> setSavedLink(List<String> savedlink) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('savelink', savedlink);
}

Future<dynamic> getSearchHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final _SearchHistory = prefs.getStringList('SearchHistory');
  if (_SearchHistory == null)
    return [''];
  else
    return _SearchHistory;
} //it will access device storage and returns the current branch

Future<void> setSearchHistory(List<String> history) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('SearchHistory', history);
}
