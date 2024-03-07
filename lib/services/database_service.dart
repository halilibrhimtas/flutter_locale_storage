import 'dart:developer';

import 'package:flutter_locale_storage/data/entity/person.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const int _version = 1;
  static const String _dbName = "persons.db";

  static Future<Database> _getDB() async {
    var databasesPath = await getDatabasesPath();
    log(databasesPath);
    return openDatabase(join(databasesPath, _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Person(id INTEGER PRIMARY KEY, name TEXT NOT NULL, saveDate TEXT NOT NULL);"), version: _version);
  }

  static Future<int> addPerson(Person person) async {
    final db = await _getDB();
    return await db.insert("Person", person.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Person?> getPerson(int id) async {
    final db = await _getDB();
    List<Map<String, Object?>> maps = await db.query("Person", where: 'id = ?', whereArgs: [id]);

    if(maps.isEmpty) {
      return null;
    }
    List<Person> persons = List.generate(maps.length, (index) => Person.fromJson(maps[index]));
    return persons[0];
  }

}
