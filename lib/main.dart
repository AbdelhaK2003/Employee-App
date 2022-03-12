import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:login/screens/routes.dart';
import 'package:login/screens/sign_in/sign_in_screen.dart';
import 'package:login/screens/theme.dart';

Future<void> main() async {
  RenderErrorBox.backgroundColor = Colors.white;
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xEB1E1F69)),
        ),
      );
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
