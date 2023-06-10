import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _textController = TextEditingController();

  String? word;
  String? def;
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

  final btnStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]!),
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Words'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 320,
                child: TextFormField(
                  onChanged: fetchData,
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Enter word',
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){},
                style: btnStyle,
                child: Text("MEANING",style: Theme.of(context).textTheme.labelLarge,),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(word??""),
                          const SizedBox(height: 20,),
                          Text(def??""),
                        ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
