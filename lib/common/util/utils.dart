import 'package:shared_preferences/shared_preferences.dart';

Future<String> getId() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('id');
  return id ?? '';
}
