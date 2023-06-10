import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class WordList {
  final int? id;
  final String word;
  final String meaning;

  WordList({this.id, required this.word, required this.meaning});

  factory WordList.fromMap(Map<String, dynamic> json) => WordList
    ( id: json['id'],
    word: json['word'],
    meaning: json['meaning'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning
    };
  }
}

class DatabaseHelper{
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'words.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE words(
        id INTEGER PRIMARY KEY,
        word TEXT,
        meaning TEXT
      )
      ''');
  }

  Future<List<WordList>> getWords() async {
    Database db = await instance.database;
    var words = await db.query('words',orderBy: 'id');
    List<WordList> wordList = words.isNotEmpty
        ? words.map((e) => WordList.fromMap(e)).toList()
        : [];
    return wordList;
  }

  Future<int> add(WordList wordlist) async {
    Database db = await instance.database;
    return await db.insert('words', wordlist.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('words', where: 'id = ?', whereArgs: [id]);
  }
}