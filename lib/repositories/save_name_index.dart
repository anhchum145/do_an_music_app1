import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveIndex(int index) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('index', 10);
}

Future<int?> readIndex() async {
  final prefs = await SharedPreferences.getInstance();
  final int? index = prefs.getInt('index');
  return index;
}

Future<void> saveEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
}

Future<void> savePass(String pass) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('pass', pass);
}

Future<String?> readEmail() async {
  final prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString('email');
  return email;
}

Future<String?> readPass() async {
  final prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString('pass');
  return email;
}

Future<List<String>?> readListLove() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? email = prefs.getStringList('email');
  return email;
}

Future<void> saveListLove(List<String> pass) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList("love", pass);
}
