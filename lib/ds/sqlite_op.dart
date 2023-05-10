import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteOp {
  Future<Database>? database;
  Future<Database> openSqliteDatabase() async {
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
    
    final database = databaseFactory.openDatabase(join(await getDatabasesPath(), "redis.db"),
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) {
            db.execute('''
        CREATE TABLE IF NOT EXISTS conn_info(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          host TEXT,
          port INTEGER,
          username TEXT,
          password TEXT
        )
      ''');
          },
        ));
    this.database = database;
    return database;
  }
}
