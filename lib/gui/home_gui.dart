import 'package:flutter/material.dart';
import 'package:redis_gui_manager/gui/redis_ops_gui.dart';
import 'menubar_gui.dart';

class HomeGui extends StatelessWidget {
  const HomeGui({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const MenuBarGui(),
      Row(
        children: const <Widget>[ RedisOpsGui()],
      )
    ]);
  }
}
