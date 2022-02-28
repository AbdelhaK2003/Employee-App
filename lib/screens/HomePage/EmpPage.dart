import 'package:flutter/material.dart';

class EmpPage extends StatefulWidget {
  const EmpPage({Key? key}) : super(key: key);

  @override
  _EmpPageState createState() => _EmpPageState();
}

class _EmpPageState extends State<EmpPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: Text('Emp page')),
    );
  }
}
