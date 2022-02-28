import 'package:flutter/material.dart';
import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  final String email;
  final String password;
  CompleteProfileScreen({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        email: this.email,
        password: this.password,
      ),
    );
  }
}
