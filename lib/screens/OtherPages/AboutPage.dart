import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(Colors.white.value)),
          title: const Text('About'),
          backgroundColor: Color(Color(0xEB1E1F69).value),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            Row(
              children: [
                Icon(Icons.info),
                Text("About"),
              ],
            ),
            Text('This page is about informations of the app .'),
            Text(
                'The Employee app was builde for a project of our school \'Ecole Superieure de Technologie d\'Agadir(ESTA)\' '),
            Text(
                'The project is devoloped by tree students , Abde elhaq MAHFOUD , Mohamed amine HNIOUA et Anas KAZAY '),
            Text(''),
          ],
        ));
  }
}
