import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redis/redis.dart' as redis;
import 'package:redis_gui_manager/ds/redis_datasource.dart';

import '../ds/redis_connection_info.dart';

class RedisOpsGui extends StatefulWidget {
  const RedisOpsGui({super.key});

  @override
  State<StatefulWidget> createState() {
    return RedisOpsState();
  }
}

class RedisOpsState extends State with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<RedisSessionModel>(builder: (context, sessions, child) {
      var tabController =
          TabController(length: sessions.sessions.length + 1, vsync: this);
      List<Tab> tabs = [
        const Tab(
          text: "帮助",
        ),
      ];
      List<Widget> views = [
        Center(
          child: Column(children: const [
            Text(
              "本页对使用方式进行一些简单说明,",
              textAlign: TextAlign.left,
            ),
            Text(
              "除帮助页之外，其他标签页可以通过双击标签来进行关闭",
              textAlign: TextAlign.left,
            ),
            Text(
              "目前只能从快速连接来开始对redis服务进行连接",
              textAlign: TextAlign.left,
            ),
          ]),
        )
      ];
      for (var connInfo in sessions.sessions) {
        tabs.add(Tab(
            child: GestureDetector(
          child: Text(connInfo.name),
          onDoubleTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Text("确认关闭标签页吗?"),
                      content: const Text("双击标签页可以关闭标签页"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("取消")),
                        TextButton(
                            onPressed: () {
                              Provider.of<RedisSessionModel>(context,
                                      listen: false)
                                  .remove(connInfo.id!);

                              Navigator.of(context).pop();
                            },
                            child: const Text("确认"))
                      ]);
                });
          },
        )));
        views.add(RedisOpsBodyPanel(connInfo: connInfo));
      }
      return SizedBox(
          width: size.width,
          height: size.height - 50,
          child: Scaffold(
            appBar: TabBar(
                controller: tabController, labelColor: Colors.blue, tabs: tabs),
            body: TabBarView(
              controller: tabController,
              children: views,
            ),
          ));
    });
  }
}

class RedisOpsBodyPanel extends StatefulWidget {
  final RedisConnectionInfo connInfo;
  late RedisDatasource redisDatasource;
  RedisOpsBodyPanel({super.key, required this.connInfo}) {
    redisDatasource = RedisDatasource(1, 3, connInfo.host, connInfo.port,
        connInfo.userName, connInfo.password);
  }

  @override
  State<RedisOpsBodyPanel> createState() {
    return RedisOpsBodyState();
  }
}

class RedisOpsBodyState extends State<RedisOpsBodyPanel> {
  late RedisDatasource redisDatasource = widget.redisDatasource;
  List<Widget> dbs = [];
  int i = 0;
  @override
  @mustCallSuper
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var cmd = redisDatasource.getCommand();
      if (dbs.isEmpty) {
        cmd.then((redis.Command command) {
          command.send_object(["config", "get", "databases"]).then((value) {
            if (value is List) {
              setState(() {
                for (int i = 0; i < int.parse(value[1]); i++) {
                  dbs.add(TextButton(onPressed: () {}, child: Text("db$i")));
                }
              });
            }
          });
        }).whenComplete(() {
          redisDatasource.releaseConnection(cmd);
        });
      }
      var redisCommandController = TextEditingController();;
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Row(
          children: [
            Column(
              children: <Widget>[
                Text("${widget.connInfo.name}:${widget.connInfo.port}"),
                Column(
                  children: dbs,
                )
              ],
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 175,
                      child: const Text("Console output"),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: "redis command",
                      ),
                      controller: redisCommandController,
                      onEditingComplete: () {
                        var cmd = redisDatasource.getCommand();
                        cmd.then((value) {
                          var str = redisCommandController.text;
                          if(str.isEmpty||str.trim().isEmpty){
                            return;
                          }
                          List<String> sep = redisCommandController.text.split(" ");
                          
                          List<String> cmds = [];
                          for (var s in sep) {
                            if (s.isNotEmpty) {
                              cmds.add(s);
                            }
                          }

                          value.send_object(cmds).then((value) {
                            print("response:$value");
                          });
                        }).whenComplete(() {
                          redisDatasource.releaseConnection(cmd);
                        });
                      },
                      
                    ),
                    const Text("server state")
                  ],
                ))
          ],
        ),
      );
    });
  }
}

/// 触发标签页增加或者删除
class RedisSessionModel extends ChangeNotifier {
  List<RedisConnectionInfo> sessions = [];

  void addOrReplace(RedisConnectionInfo session) {
    int i = -1;
    for (var s in sessions) {
      i++;
      if (s.id == session.id) {
        break;
      }
    }
    if (i < 0) {
      sessions.add(session);
    } else {
      sessions.replaceRange(i, i + 1, [session]);
    }
    notifyListeners();
  }

  void remove(int id) {
    int idx = 0;
    for (var session in sessions) {
      if (session.id == id) {
        break;
      }
      idx++;
    }
    sessions.removeAt(idx);
    notifyListeners();
  }
}
