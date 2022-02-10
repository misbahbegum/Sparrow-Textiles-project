import 'package:flutter/material.dart';
import 'package:godownmanager/widgets/drawer.dart';

// ignore: camel_case_types
class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);

  @override
  // ignore: override_on_non_overriding_member
  Widget build(BuildContext context) {
    String name = 'home';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sparrow Textiles"),
      ),
      body: Center(
        child: Text('hey, this is $name'),
      ),
      drawer: const mydrawer(),
    );
  }
}
