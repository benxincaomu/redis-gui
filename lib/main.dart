import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redis_gui_manager/gui/server_list_panel.dart';
import 'gui/home_gui.dart';

void main() {
    var serverListModel = ServerListModel();
    serverListModel.refresh();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => serverListModel,)
    ], child: const MainApp())
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: HomeGui()));
  }
}
