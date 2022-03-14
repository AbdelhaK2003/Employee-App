import 'package:flutter/material.dart';
import 'package:login/screens/size_config.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(),
      body: Body(),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double barHeight = 50.0;
  //MainAppBar({Key key, this.title}) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 150.0);
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          child: SizedBox(
            height: 500,
            child: Container(
              color: Color.fromRGBO(30, 31, 105, 0.922),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/workers.png',
                    width: 135,
                    height: 135,
                  ),
                ],
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight + 220));
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
