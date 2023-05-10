import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:redis_gui_manager/gui/server_list_model.dart';
import 'gui/home_gui.dart';
import 'gui/redis_ops_gui.dart';

void main() {
  _loadLibrary()
  var serverListModel = ServerListModel();
  serverListModel.refresh();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => serverListModel,
    ),
    ChangeNotifierProvider(create: (context) => RedisSessionModel())
  ], child: const MainApp()));
}

DynamicLibrary? _loadLibrary() {
  if (Platform.isWindows || kReleaseMode) {
    final scriptDir = File(Platform.script.toFilePath()).parent;
    final libraryNextToScript = File(join(scriptDir.path, 'sqlite3.dll'));
    return DynamicLibrary.open(libraryNextToScript.path);
  }
  return null;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const Scaffold(body: HomeGui()),
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey,
          primaryTextTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: 18),
            bodyMedium: TextStyle(fontSize: 24),
            bodyLarge: TextStyle(fontSize: 30),
            titleSmall: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(
                fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontSize: 18, color: Colors.black),
            displayMedium: TextStyle(fontSize: 24, color: Colors.black),
            displayLarge: TextStyle(fontSize: 30, color: Colors.black),
            labelSmall: TextStyle(fontSize: 18, color: Colors.black),
            labelMedium: TextStyle(fontSize: 24, color: Colors.black),
            labelLarge: TextStyle(fontSize: 30, color: Colors.black),
          ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: 18),
            bodyMedium: TextStyle(fontSize: 24),
            bodyLarge: TextStyle(fontSize: 30),
            titleSmall: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(
                fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontSize: 18, color: Colors.black),
            displayMedium: TextStyle(fontSize: 24, color: Colors.black),
            displayLarge: TextStyle(fontSize: 30, color: Colors.black),
            labelSmall: TextStyle(fontSize: 18, color: Colors.black),
            labelMedium: TextStyle(fontSize: 24, color: Colors.black),
            labelLarge: TextStyle(fontSize: 30, color: Colors.black),
          ),
        ));
  }
}
