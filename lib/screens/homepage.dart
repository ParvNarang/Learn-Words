import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:learning_words/functions/text_to_speech.dart';
import 'package:learning_words/sql/sql_connection.dart';
import 'package:learning_words/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_words/functions/storing_in_shared_preferences.dart';
import 'package:learning_words/functions/show_notifications.dart';

bool switchValue = false;

class HomePageSql extends StatefulWidget {
  const HomePageSql({Key? key}) : super(key: key);
  @override
  State<HomePageSql> createState() => _HomePageSqlState();
}

class _HomePageSqlState extends State<HomePageSql> {
  late final _textController = TextEditingController();
  String? word = '';
  String? def;
  var timeInterval = {
    '1 min':1,
    '30 mins':30,
    '45 mins':45,
    '1 hr':60,
    '6 hrs':360,
    '12 hrs':720
  };
  String dropDownValue = '30 mins';
  var items = [
    '1 min',
    '30 mins',
    '45 mins',
    '1 hr',
    '6 hrs',
    '12 hrs',
  ];

  Future<void> fetchData(String rnd) async {
    final String apiUrl = "https://api.urbandictionary.com/v0/define?term=${_textController.text}";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body);
      setState(() {
        word = jsonList['list'][0]['word'];
        def = jsonList['list'][0]['definition'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  getBoolValuesSFSwitch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('boolValue');
    setState(() {
      switchValue = boolValue!;
    });// print(switchValue); //return boolValue;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  late ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    getBoolValuesSFSwitch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn New Words'),
        backgroundColor: bgColor,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              word!.isNotEmpty?
              Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: white,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(word??""),
                        const SizedBox(height: 20,),
                        Text(def??""),
                        const Text("\n"),
                        const Divider(thickness: 1,)
                      ],
                    ),
                  ),
              ) : const SizedBox(),
              Container(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 215,
                        child: TextFormField(
                          onChanged: fetchData,
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Search word',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: () async{
                          _textController.text.isNotEmpty
                          ? await DatabaseHelper.instance.add(
                            WordList(word: word??"", meaning: def??"")
                          )
                          : print("not added");
                          setState(() {
                            _textController.clear();
                            word="";
                            def="";
                          });
                        },
                        style: btnStyle,
                        child: Text("+",style: Theme.of(context).textTheme.labelLarge,),
                      ),
                      const SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _textController.clear();
                            word="";
                            def="";
                          });
                        },
                        style: btnStyle,
                        child: Text("CLEAR",style: Theme.of(context).textTheme.labelLarge,),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(22),bottomRight: Radius.circular(22)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFEEEEEE),
                      blurRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Reminder", style: TextStyle(fontSize: 17),),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton(
                      value: dropDownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      borderRadius: BorderRadius.circular(5),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                          if(switchValue==true) AndroidAlarmManager.periodic(Duration(minutes: timeInterval[dropDownValue]!), 0, showNotification);// print(dropDownValue);
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Switch(
                      trackColor: MaterialStateProperty.all(Colors.black38),
                      inactiveThumbColor: Colors.grey.withOpacity(0.4),
                      activeColor: bgColor,
                      value: switchValue,
                      onChanged: (value) => setState(() {
                        switchValue = value;
                        if(switchValue==true){
                          addBoolToSFTrue();
                          AwesomeNotifications().requestPermissionToSendNotifications();
                          AndroidAlarmManager.periodic(Duration(minutes: timeInterval[dropDownValue]!), 0, showNotification);
                        }
                        else{// print("not sending");
                          addBoolToSFFalse();
                          AndroidAlarmManager.cancel(0);
                        }
                      }),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<WordList>>
                (
                future: DatabaseHelper.instance.getWords(),
                builder: (BuildContext context, AsyncSnapshot<List<WordList>> snapshot)
                {
                  if(!snapshot.hasData){
                    return const Center(
                      child: CircularProgressIndicator()
                    );
                  }
                  return snapshot.data!.isEmpty
                    ? const Center(child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text("You can search & add new words",style: TextStyle(fontSize: 12),),
                    ),)
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15,top: 16,bottom: 10,),
                          child: Text("Daily Words", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                        ),
                        Divider(color: Colors.grey[400],indent: 15,endIndent: 15,),
                        Scrollbar(
                          controller: _scrollController,
                          child: ListView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            reverse: true,
                            children: snapshot.data!.map((word) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: ListTile(
                                      onLongPress: (){
                                        setState(() {
                                          DatabaseHelper.instance.remove(word.id!);
                                        });
                                      },
                                      onTap: (){textToSpeech(word.word);},
                                      // leading: Text(word.id.toString()),
                                      title: Text("\n${word.word}"),
                                      subtitle: Text("${word.meaning}\n"),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),),
                    ],
                    );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}