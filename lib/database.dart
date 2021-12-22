import 'package:flutter/material.dart';
import 'package:image_storing_pract/profile_model.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' as path;

class DatabaseHelper {
  static const tableName = "profiletable";
  static const dbVersion = 1;

  static const idColumn = "id";
  static const nameColumn = "name";
  static const image64bitColumn = "image64bit";

  static Future _onCreate(Database db, int version) {
    return db.execute("""
    CREATE TABLE $tableName(
    $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $nameColumn TEXT,
    $image64bitColumn TEXT
    
    )    
    """);
  }

  static open() async {
    final rootPath = await getDatabasesPath();

    print("DB OPENED");
    final dbPath = path.join(rootPath, "GosolDb.db");

    return openDatabase(dbPath, onCreate: _onCreate, version: dbVersion);
  }

  static Future insertProfile(Map<String, dynamic> row) async {
    final db = await DatabaseHelper.open();
    print("ROW INSERTED");
    return await db.insert(tableName, row);
  }

  static getAllProfile() async {
    final db = await DatabaseHelper.open();

    List<Map<String, dynamic>> mapList = await db.query(tableName);

    return List.generate(
        mapList.length, (index) => ProfileModel.fromMap(mapList[index]));
  }
}
