// ignore_for_file: avoid_print

import 'dart:io';
import 'package:chasski/sqllite/db_create_tables.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBLocalStorage {
  Database? _database;

  DBLocalStorage._();
  static final DBLocalStorage instance = DBLocalStorage._();

  Future<Database> checkinDatabase() async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDataBase();
      return _database!;
    }
  }

  Future<Database> initDataBase() async {
    // Directory directory = await getApplicationCacheDirectory();//asociada con la memoria cache
    Directory directory =
        await getApplicationDocumentsDirectory(); //asociada con la memoria Docuemnto
    String path = join(directory.path, 'andesRace2.db');

    return await openDatabase(
      path,
      version: 3,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        print('Database path: $path');
        await DatabaseTablesDB.createTables(db);
      },
    );
  }
}
