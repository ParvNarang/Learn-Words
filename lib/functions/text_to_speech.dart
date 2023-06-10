import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

void textToSpeech(String text) async {
  await flutterTts.setLanguage("en-IN");
  await flutterTts.setVolume(0.5);
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setPitch(1);
  await flutterTts.speak(text);
}