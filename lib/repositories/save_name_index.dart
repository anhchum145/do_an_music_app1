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
