import 'sqlite_op.dart';
import 'redis_connection_info.dart';

class ConnInfoMapSqlite {
  var database = SqliteOp(databseName: 'redis').openSqliteDatabase();
  ConnInfoMapSqlite() {
    checkOrCreateTable();
  }

  void checkOrCreateTable() async {
    var db = await database;
    var result = db.rawQuery(
        "SELECT count(*) FROM sqlite_master WHERE type=\"table\" AND name = \"conn_info\"");
    result.then((value) {
      if (value.isEmpty) {
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
      }
    });
  }

  /// 插入一条连接信息
  Future<int> insertOne(RedisConnectionInfo connInfo) async {
    var db = await database;
    return db.insert('conn_info', connInfo.toMap());
  }

  /// 删除一条连接信息
  /// id: 连接信息的id
  Future<int> deleteOne(int id) async {
    var db = await database;
    return db.delete('conn_info', where: 'id = ?', whereArgs: [id]);
  }

  /// 修改一条连接信息 
  /// connInfo: 连接信息
  Future<int> updateOne(RedisConnectionInfo connInfo) async {
    var db = await database;
    return db.update('conn_info', connInfo.toMap(),
        where: 'id = ?', whereArgs: [connInfo.id]);
  }

  /// 查询所有的连接信息
  Future<List<RedisConnectionInfo>> queryAllConnection() async {
    var db = await database;
    Future<List<Map<String,dynamic>>> res = db.rawQuery('conn_info');
    List<RedisConnectionInfo> connInfos = [];
    res.then((value) {
      if(value.isNotEmpty) {
        for (var element in value) {
          connInfos.add(RedisConnectionInfo(
            id: element['id'] ,
            name: element['name'],
            host: element['host'],
            port: element['port'],
            userName: element['username'],
            password: element['password']
          ));
        }
      }

    });
    return connInfos;
  }
}
