//import 'dart:js';

import 'package:flutter/widgets.dart';
import 'package:login/screens/ChatPage/ChatPage.dart';
import 'package:login/screens/HomePage/Homepage.dart';
import 'package:login/screens/SearchPage/SearchPage.dart';
import 'package:login/screens/complete_profile/complete_profile_screen.dart';
import 'package:login/screens/forgot_password/forgot_password_screen.dart';
import 'package:login/screens/sign_in/sign_in_screen.dart';
import 'package:login/screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  //CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  HomePage.routeName: (context) => HomePage(),
  ChatPage.routeName: (context) => ChatPage(),
  SearchPage.routeName: (context) => SearchPage(),
};
