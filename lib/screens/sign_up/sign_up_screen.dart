import 'package:flutter/material.dart';
import 'package:login/screens/size_config.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Body(),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double barHeight = 50.0;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 150.0);
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(0),
          ),
          child: Container(
            color: Color(0xEB1E1F69),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Text(
                  "Sign in",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: getProportionateScreenWidth(35),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight + 230));
  }
}

class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    final lowPoint = size.height - 30;
    final highPoint = size.height - 60;
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, lowPoint);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
