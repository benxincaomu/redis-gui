import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart';
import "package:flutter/widgets.dart";
import 'package:sqflite/sqflite.dart';

class SqliteOp {
  Future<Database> openSqliteDatabase(String databseName) async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), databseName),
    );
    return database;
  }
}
