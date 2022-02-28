import 'package:flutter/material.dart';
import 'package:login/screens/sign_up/sign_up_screen.dart';

import 'package:login/screens/constants.dart';
import 'package:login/screens/size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Créer un compte Gratuitement ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "S'inscrire",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
