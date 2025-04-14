// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class UseAvoidEmptyContainerRule extends StatelessWidget {
  const UseAvoidEmptyContainerRule({super.key});

  @override
  Widget build(BuildContext context) {
    // expect_lint: avoid_empty_container
    final widget = Container();

    if (true) {
      // expect_lint: avoid_empty_container
      Container();
      // expect_lint: avoid_empty_container
      Container(child: Container());
    }

    // expect_lint: avoid_empty_container
    return Column(children: [widget, Container()]);
  }
}
