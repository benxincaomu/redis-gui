import 'sqlite_op.dart';
import 'redis_connection_info.dart';

class ConnInfoMapSqlite {
  var database = SqliteOp().openSqliteDatabase();


  /// 插入一条连接信息
  Future<int> insertOne(RedisConnectionInfo connInfo) async {
    var db = await database;
    return db.insert('conn_info', connInfo.toMap());
  }

  Future<RedisConnectionInfo> selectLastOne() async {
    var db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery('select * from conn_info order by id desc limit 1');
    if (res.isNotEmpty) {
      return RedisConnectionInfo(
          id: res[0]['id'],
          name: res[0]['name'],
          host: res[0]['host'],
          port: res[0]['port'],
          userName: res[0]['username'],
          password: res[0]['password']);
    }else{
      // ignore: null_argument_to_non_null_type
      return Future.value();
    }
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
    List<Map<String, dynamic>> res =
        await db.rawQuery('select * from conn_info');
    List<RedisConnectionInfo> connInfos = [];
    if (res.isNotEmpty) {
      for (var element in res) {
        connInfos.add(RedisConnectionInfo(
            id: element['id'],
            name: element['name'],
            host: element['host'],
            port: element['port'],
            userName: element['username'],
            password: element['password']));
      }
    }
    return connInfos;
  }

}
