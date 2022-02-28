// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AddWork extends StatefulWidget {
  const AddWork({Key? key}) : super(key: key);

  @override
  _AddWorkState createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add work'),
        backgroundColor: Color(Color(0xEB1E1F69).value),
      ),
      body: Center(
        child: Text("Add work Page"),
      ),
    );
  }
}
