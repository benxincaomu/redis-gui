import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        views.add(const Center(child: Text("连接中...")));
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
