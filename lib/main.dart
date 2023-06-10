import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:learning_words/functions/show_notifications.dart';
import 'package:learning_words/screens/homepage.dart';
import 'functions/storing_in_shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  initializeNotifications();
  await AndroidAlarmManager.initialize();
  bool firstRun = await IsFirstRun.isFirstRun();
  // print(firstRun);
  if(firstRun){
    addBoolToSFFalse();
  }
  runApp(const MyApp());
}
//converted to stateful
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Learn Words',
      debugShowCheckedModeBanner: false,
      home: HomePageSql()
    );
  }
}