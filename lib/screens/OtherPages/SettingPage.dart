import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

bool _switchValue = false;

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(Colors.white.value)),
          title: const Text('Settings'),
          backgroundColor: Color(Color(0xEB1E1F69).value),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            //  shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Text(
                'Account',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Color(0xEB1E1F69),
                endIndent: 20,
                indent: 10,
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete your account'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.notifications_off),
                title: Text('Turn off notifications'),
                onTap: () {},
              ),
              Text(
                'Application',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Color(0xEB1E1F69),
                endIndent: 20,
                indent: 10,
              ),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Dark theme'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Security and privacy'),
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}
