import "package:flutter/material.dart";

class ConnectionInfoPannel extends StatefulWidget {
  const ConnectionInfoPannel({super.key});

  void save() {}
  void cancel() {}

  @override
  State<StatefulWidget> createState() {
    return ConnectionInfoPannelState();
  }
}

class ConnectionInfoPannelState extends State<ConnectionInfoPannel> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final serverAddressController = TextEditingController();
  final serverPortController = TextEditingController();

  final userNameController = TextEditingController();

  final passwordController = TextEditingController();

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
          controller: serverAddressController),
          TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "端口",
              ),
              controller: serverPortController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
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
        ]));
  }
}
