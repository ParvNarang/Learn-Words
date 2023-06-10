import 'package:shared_preferences/shared_preferences.dart';

addBoolToSFFalse() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('boolValue', false);
  // print("Set to False");
}

addBoolToSFTrue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('boolValue', true);
  // print("Set to True");
}