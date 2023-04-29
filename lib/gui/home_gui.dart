import 'package:flutter/material.dart';
import 'menubar_gui.dart';

class HomeGui extends StatelessWidget {
  const HomeGui({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [MenuBarGui()]
    );
  }
}
