import 'package:flutter/material.dart';
import 'package:login/screens/size_config.dart';
import 'complete_profile_form.dart';

class Body extends StatelessWidget {
  final String email;
  final String password;
  Body({Key? key, required this.email, required this.password})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                CompleteProfileForm(
                  email: this.email,
                  password: this.password,
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
