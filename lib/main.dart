import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/HomePage/Homepage.dart';
import 'package:login/screens/routes.dart';
import 'package:login/screens/sign_in/sign_in_screen.dart';
import 'package:login/screens/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmployeApp',
      theme: theme(),
      initialRoute: SignInScreen.routeName,
      routes: routes,
    );
  }
}
