
import 'package:path/path.dart';
import "package:flutter/widgets.dart";
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteOp {
  final String databseName;
  Future<Database>? database;
  SqliteOp({required this.databseName});
  Future<Database> openSqliteDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    databaseFactory = databaseFactoryFfi;
    final database = openDatabase(
      join(await getDatabasesPath(), databseName),
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE IF NOT EXISTS conn_info(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          host TEXT,
          port INTEGER,
          username TEXT,
          password TEXT
        )
      '''),
    );
    this.database = database;
    return database;
  }

  Future<void> insertOne(Object obj) async {
    var db = await database;
    
  }
}
