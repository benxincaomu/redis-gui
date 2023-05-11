import 'dart:collection';

import 'package:redis/redis.dart';

class RedisDatasource {
  int initConns = 1;
  int maxConns = 10;
  int currConns = 0;
  String host;
  int port;
  String? username;
  String? password;
  Queue<Future<Command>> commands = DoubleLinkedQueue<Future<Command>>();

  RedisDatasource(this.initConns, this.maxConns, this.host, this.port,
      this.username, this.password) {
    for (int i = 0; i < initConns && i < maxConns; i++) {
      commands.add(_initConnection());
    }
    currConns = commands.length;
  }
  Future<Command> _initConnection() {
    var conn = RedisConnection();
    if (username == null ||
        username!.isEmpty ||
        password == null ||
        password!.isEmpty) {
      var cn = conn.connect(host, port);
      commands.add(cn);
      return cn;
    } else {
      var cn = conn.connectSecure(host, port);
      cn.then((Command command) {
        command.send_object(["AUTH", username, password]);
      });
      commands.add(cn);
      return cn;
    }
  }

  void releaseConnection(Future<Command> command) {
    commands.add(command);
  }

  Future<Command> getCommand() {
    if (commands.isNotEmpty) {
      return commands.removeFirst();
    } else if (currConns < maxConns) {
      var conn = _initConnection();
      currConns++;
      return conn;
    } else {
      throw Exception("No more connections available");
    }
  }
}
