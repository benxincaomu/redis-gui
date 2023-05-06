import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redis_gui_manager/ds/redis_connection_info.dart';
import 'package:redis_gui_manager/ds/sqlite_op.dart';

class ServerListPanel extends StatefulWidget {
  const ServerListPanel({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ServerListState();
  }
}

class ServerListState extends State {
  @override
  Widget build(BuildContext context) {
    /* return Row(
      children: const <Widget>[
        Text("redis服务列表"),
      ],
    ); */
    return Consumer<ServerListModel>(builder: (context, serverListModel, child) {
      List<Container> list = [];
      for (var element in serverListModel.conns) {
       list.add(Container(
          child: Text(element.name),
       )) ;
      }
      return Row(children: list,);
    });
  }
}

class ServerListModel extends ChangeNotifier {
  List<RedisConnectionInfo> conns = [];

  void refresh() async{
    conns.clear();
    var database = SqliteOp().openSqliteDatabase();
    var db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery('select * from conn_info');
    if (res.isNotEmpty) {
      for (var element in res) {
        conns.add(RedisConnectionInfo(
            id: element['id'],
            name: element['name'],
            host: element['host'],
            port: element['port'],
            userName: element['username'],
            password: element['password']));
      }
    }

    notifyListeners();
  }
}
