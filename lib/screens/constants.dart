import 'package:flutter/material.dart';
import 'package:login/screens/size_config.dart';

const kPrimaryColor = Color(0xEB1E1F69);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
//const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

//const kAnimationDuration = Duration(milliseconds: 200);

/*final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);*/

//const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Enter your email";
const String kInvalidEmailError = "Enter a valide email";
const String kPassNullError = "Enter a valide password";
const String kShortPassError = "Weak password ! try another one";
const String kMatchPassError = "Password incorrect";
const String kNamelNullError = "Enter your last name";
const String kPhoneNumberNullError = "Enter your phone";
const String kAddressNullError = "Enter your adress";

/*final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);*/

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
