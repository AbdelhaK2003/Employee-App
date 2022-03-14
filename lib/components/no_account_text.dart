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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /* Text(
          "Créer un compte Gratuitement ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ), */
        SizedBox(
          width: double.infinity,
          height: getProportionateScreenHeight(56),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Color(0xEB1E1F69))))),
            onPressed: () {
              Navigator.pushNamed(context, SignUpScreen.routeName);
            },
            child: Text(
              'Sign in',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: Color(0xEB1E1F69),
              ),
            ),
          ),
        ),
        /* GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "S'inscrire",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor,
                decoration: TextDecoration.underline),
          ),
        ), */
      ],
    );
  }
}
