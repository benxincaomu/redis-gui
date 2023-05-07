import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:redis_gui_manager/gui/redis_ops_gui.dart';
import 'package:redis_gui_manager/gui/server_list_panel.dart';
import '../ds/redis_connection_info.dart';
import '../ds/conn_info_map_sqlite.dart';

class ConnectionInfoPannel extends StatefulWidget {
  //final state = ConnectionInfoPannelState();
  const ConnectionInfoPannel({super.key});

  void save() {
    //state.save();
  }

  void cancel() {}

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return ConnectionInfoPannelState();
  }
}

class ConnectionInfoPannelState extends State<ConnectionInfoPannel> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: "localhost");
  final hostController = TextEditingController(text: "127.0.0.1");
  final portController = TextEditingController(text: "6379");

  final userNameController = TextEditingController();

  final passwordController = TextEditingController();
  final connInfoMap = ConnInfoMapSqlite();

  @override
  Widget build(BuildContext context) {
    const fontStyle = TextStyle(fontSize: 24);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(children: [
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "名称",
            labelStyle: fontStyle,
          ),
          style: fontStyle,
          controller: nameController,
        ),
        TextFormField(
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "服务地址",
                labelStyle: fontStyle),
            style: fontStyle,
            controller: hostController),
        TextFormField(
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "端口",
                labelStyle: fontStyle),
            style: fontStyle,
            controller: portController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null &&
                  value.isNotEmpty &&
                  int.tryParse(value) != null) {
                return null;
              }
              return "端口号必须是整数";
            }),
        TextFormField(
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "用户名",
              labelStyle: fontStyle),
          style: fontStyle,
          controller: userNameController,
        ),
        TextFormField(
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "密码",
              labelStyle: fontStyle),
          style: fontStyle,
          controller: passwordController,
          obscureText: true,
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
              onPressed: () {
                save();
                Navigator.pop(context);
              },
              child: const Text("保存")),
        )
      ]),
    );
  }

  Future<int> save() {
    if (_formKey.currentState!.validate()) {
      var conn = RedisConnectionInfo(
          name: nameController.text,
          host: hostController.text,
          port: int.parse(portController.text),
          userName: userNameController.text,
          password: passwordController.text);
      Future<int> res = connInfoMap.insertOne(conn);
      Provider.of<ServerListModel>(context, listen: false).refresh();
      var lastOne = connInfoMap.selectLastOne();
      lastOne.then((value) =>
          Provider.of<RedisSessionModel>(context, listen: false).add(value));

      return res;
    } else {}
    return Future.value(0);
  }
}
