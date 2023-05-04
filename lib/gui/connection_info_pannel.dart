import "package:flutter/material.dart";
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
  final nameController = TextEditingController();
  final hostController = TextEditingController();
  final portController = TextEditingController();

  final userNameController = TextEditingController();

  final passwordController = TextEditingController();
  final connInfoMap = ConnInfoMapSqlite();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(children: [
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "名称",
          ),
          controller: nameController,
        ),
        TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "服务地址",
            ),
            controller: hostController),
        TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "端口",
            ),
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
          ),
          controller: userNameController,
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "密码",
          ),
          controller: passwordController,
          obscureText: true,
        ),
        Container(margin: const EdgeInsets.only(top: 20),child:ElevatedButton(
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
      return connInfoMap.insertOne(conn);
    } else {}
    return Future.value(0);
  }
}
