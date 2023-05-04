import 'package:flutter/material.dart';
import "connection_info_pannel.dart";

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
                    //showAboutDialog(context: context, applicationName: "New Connection");
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
                  child: const MenuAcceleratorLabel("退出"), onPressed: () {})
            ], child: const MenuAcceleratorLabel("文件")),
            SubmenuButton(menuChildren: <Widget>[
              MenuItemButton(
                  child: const MenuAcceleratorLabel("快速连接"), onPressed: () {})
            ], child: const MenuAcceleratorLabel("连接"))
          ],
        ))
      ],
    );
  }
}
