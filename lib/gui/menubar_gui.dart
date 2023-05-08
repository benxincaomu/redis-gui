import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redis_gui_manager/ds/conn_info_map_sqlite.dart';
import 'package:redis_gui_manager/gui/redis_ops_gui.dart';
import "connection_info_pannel.dart";
import 'server_list_panel.dart';

class MenuBarGui extends StatelessWidget {
  const MenuBarGui({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
            child: MenuBar(
          children: <Widget>[
            SubmenuButton(menuChildren: <Widget>[
              MenuItemButton(
                  child: const MenuAcceleratorLabel("新连接"),
                  onPressed: () {
                    const connectionInfoPannel = ConnectionInfoPannel();
                    showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                              title: Text("新连接"),
                              content: SizedBox(
                                width: 500,
                                height: 500,
                                child: connectionInfoPannel,
                              ),
                            ));
                  }),
              MenuItemButton(
                  child: const MenuAcceleratorLabel("退出"),
                  onPressed: () {
                    // exit(0);
                  })
            ], child: const MenuAcceleratorLabel("文件")),
            Consumer<ServerListModel>(
                builder: (context, connectionInfo, child) {
              final List<Widget> list = [];
              for (var conn in connectionInfo.conns) {
                list.add(SubmenuButton(
                  menuChildren: [
                    MenuItemButton(
                        child: const MenuAcceleratorLabel("连接"),
                        onPressed: () {
                          Provider.of<RedisSessionModel>(context, listen: false)
                              .addOrReplace(conn);
                        }),
                    MenuItemButton(
                        child: const MenuAcceleratorLabel("修改"),
                        onPressed: () {
                          var connectionInfoPannel = ConnectionInfoPannel(
                            connInfo: conn,
                          );
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("修改连接信息"),
                                    content: SizedBox(
                                      width: 500,
                                      height: 500,
                                      child: connectionInfoPannel,
                                    ),
                                  ));
                        }),
                    MenuItemButton(
                        child: const MenuAcceleratorLabel("删除"),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text("确认删除${conn.name}?"),
                                    content:  Text("确认删除${conn.name}"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("取消")),
                                      TextButton(
                                          onPressed: () {
                                            
                                            ConnInfoMapSqlite().deleteOne(conn.id!);
                                            Provider.of<ServerListModel>(context,listen: false).refresh();
                                            Provider.of<RedisSessionModel>(context,listen: false).remove(conn.id!);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("确认"))
                                    ]);
                              });
                        }),
                  ],
                  child: MenuAcceleratorLabel(conn.name),
                ));
              }
              return SubmenuButton(
                menuChildren: list,
                child: const MenuAcceleratorLabel("连接"),
              );
            })
          ],
        ))
      ],
    );
  }
}
