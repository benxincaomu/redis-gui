import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart';
import "package:flutter/widgets.dart";
import 'package:sqflite/sqflite.dart';

class SqliteOp {
  final String databseName;
  Future<Database>? database;
  SqliteOp({required this.databseName});
  Future<Database> openSqliteDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), databseName),
    );
    this.database = database;
    return database;
  }

  Future<void> insertOne(Object obj) async {
    var db = await database;
    
  }
}
