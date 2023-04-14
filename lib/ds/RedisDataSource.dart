import 'dart:collection';
import 'dart:ffi';

import 'package:redis/redis.dart';

class RedisDataSource {
  int initConns = 1;
  int maxConns = 10;
  int currConns = 0;
  String host;
  int port;
  String? username = null;
  String? password = null;
  Queue conns = new Queue<RedisConnection>();

  RedisDataSource(
      this.initConns, this.maxConns, this.host, this.port, this.username, this.password) {
    conns = DoubleLinkedQueue();
    for (int i = 0; i < initConns && i < maxConns; i++) {
      var conn = _initConnection();
      conns.addLast(conn);
    }
    currConns = conns.length;
  }
   RedisConnection _initConnection(){
    var conn = RedisConnection();
      if (username == null || password == null ) {
        conn.connect(host, port);
      } else {
        conn.connectSecure(host, port).then((Command command){
            command.send_object(["AUTH", username, password]);
        });
      } 
      return conn;
  }

    RedisConnection getConnection() {
        if (conns.isEmpty) {
            if (currConns < maxConns) {
                var conn = _initConnection();
                conns.addLast(conn);
                currConns++;
            } else {
                throw Exception("No more connections available");
            }
        }
        return conns.removeFirst();
    }

    void releaseConnection(RedisConnection conn) {
        conns.addLast(conn);
    }
}
