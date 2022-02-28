import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Color(0xEB1E1F69).value),
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Text("Notifications Page"),
      ),
    );
  }
}
