# Learning Words

An android app built with flutter that can be helpful in learning new words with their *meanings/definitions*.

It uses an **urban-dictionary api** to look up the *word* with its *meaning/phrase*.

<p align="center">
  <img src="https://github.com/ParvNarang/Learn-Words/blob/5bbcf8cad399cced354bddba1826dff3004d5600/screenshots/s1.png" width="300">
</p>
<p align="center">  
  <img src="https://github.com/ParvNarang/Learn-Words/blob/5bbcf8cad399cced354bddba1826dff3004d5600/screenshots/s2.png" width="300">
  <img src="https://github.com/ParvNarang/Learn-Words/blob/5bbcf8cad399cced354bddba1826dff3004d5600/screenshots/s3.png" width="300">
</p>

<p align="center">
  If that word intrigues you, you can add it to your daily list of words and even set a reminder on the app to send you local notifications periodically. You can even tap on the word added to the list to know how it's pronounced and long press on it to delete it.
</p>

- Uses sqflite & shared_preferences for local storage.
- For sending notifications it makes use of awesome_notifications package & 
  android_alarm_manager_plus to send them periodically.
- flutter_tts package to convert text to speech to pronounce the word.
- http for calling the api.
  
## Setting up a reminder

<p align="center">
  <img src="https://github.com/ParvNarang/Learn-Words/blob/5bbcf8cad399cced354bddba1826dff3004d5600/screenshots/s4.png" width="300">
  <img src="https://github.com/ParvNarang/Learn-Words/blob/5bbcf8cad399cced354bddba1826dff3004d5600/screenshots/s5.png" width="300">
</p>
