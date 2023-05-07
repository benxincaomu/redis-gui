import 'dart:io';

import 'package:flutter/material.dart';

class RedisOpsGui extends StatefulWidget {
  const RedisOpsGui({super.key});

  @override
  State<StatefulWidget> createState() {
    return RedisOpsState();
  }
}

class RedisOpsState extends State with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    stdout.writeln("${MediaQuery.of(context).size}");
    var size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        height: size.height - 50,
        child: Scaffold(
          appBar: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              tabs: const [
                Tab(
                  text: "local",

                  //icon: Icon(Icons.local_fire_department),
                ),
                Tab(
                  text: "local2",
                  //icon: Icon(Icons.local_fire_department),
                )
              ]),
          body: TabBarView(
            controller: _tabController,
            children: const <Widget>[
              Center(
                child: Text("It's cloudy here"),
              ),
              Center(
                child: Text("It's rainy here"),
              ),
            ],
          ),
        ));
  }
}
