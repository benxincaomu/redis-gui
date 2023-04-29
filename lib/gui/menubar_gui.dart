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
                  child: const MenuAcceleratorLabel("New Connection"),
                  onPressed: () {
                    //showAboutDialog(context: context, applicationName: "New Connection");
                    showDialog(context: context, builder: (context)=>const AlertDialog(
                      title: Text("New Connection"),
                      content: ConnectionInfoPannel(),
                      actions: [

                      ],
                    ));
                  }),
              MenuItemButton(
                  child: const MenuAcceleratorLabel("Quit"), onPressed: () {})
            ], child: const MenuAcceleratorLabel("File")),
            SubmenuButton(menuChildren: <Widget>[
              MenuItemButton(
                  child: const MenuAcceleratorLabel("Quick Connect"), onPressed: () {})
            ], child: const MenuAcceleratorLabel("Connections"))
          ],
        ))
      ],
    );
  }
}
