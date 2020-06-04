import 'package:shared_preferences/shared_preferences.dart';

Future<String> getName() async {
  final prefs = await SharedPreferences.getInstance();
  final _nameSelect = prefs.getString('Name');
  if (_nameSelect == null)
    return 'Name';
  else
    return _nameSelect;
}

Future<void> setName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('Name', name);
}

Future<String> getSem() async {
  final prefs = await SharedPreferences.getInstance();
  final _semSelect = prefs.getString('Sem');
  if (_semSelect == null)
    return '';
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
    return '';
  else
    return _branchSelect;
} //it will access device storage and returns the current branch

Future<void> setBranch(String branch) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('Branch', branch);
}
