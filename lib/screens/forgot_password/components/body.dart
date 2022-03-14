import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/components/custom_surfix_icon.dart';
import 'package:login/components/default_button.dart';
import 'package:login/components/form_error.dart';
import 'package:login/components/no_account_text.dart';
import 'package:login/screens/constants.dart';
import 'package:login/screens/sign_in/sign_in_screen.dart';
import 'package:login/screens/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  final auth = FirebaseAuth.instance;
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email.text = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return null;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Color(0xEB1E1F69),
                fontSize: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 2, color: Color.fromARGB(235, 30, 31, 105)),
                borderRadius: new BorderRadius.circular(25.0),
              ),
              labelText: "Email",
              hintText: "Enter your email ",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/mail-.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          //SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Verify",
            press: () {
              if (_formKey.currentState!.validate()) {
                resetPassword();
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.24),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child:
                  Text('(If you don' 't have account yet create it here !) '),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          NoAccountText(),
        ],
      ),
    );
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      Navigator.pushNamed(context, SignInScreen.routeName);
      //Utils.showSnackBar('Password Reset Email Sent');
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Password Reset Email Sent'),
      ));
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
