import 'package:flutter/material.dart';
import 'package:login/components/form_error.dart';
// ignore: unused_import
import 'package:login/helper/keyboard.dart';
import 'package:login/screens/HomePage/Homepage.dart';
import 'package:login/screens/forgot_password/forgot_password_screen.dart';
import 'package:login/screens/sign_up/sign_up_screen.dart';
import '../../../components/default_button.dart';
import 'package:login/screens/constants.dart';
import 'package:login/screens/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  bool? remember = false;

  final List<String?> errors = [];
  bool _isHidden = true;
  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "mote de passe oublié",
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 18),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
              text: "Continuer",
              press: () async {
                try {
                  await _auth
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text)
                      .then((uid) => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (contex) => HomePage())),
                          });
                } on FirebaseAuthException catch (e) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Ops! Login Failed"),
                      content: Text('${e.message}'),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: password,
      obscureText: _isHidden,
      onSaved: (value) => password.text = value!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Color(0xEB1E1F69),
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xEB1E1F69)),
          borderRadius: new BorderRadius.circular(25.0),
        ),
        labelText: "Mote de passe",
        hintText: "Entrer votre mote de passe",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffix: InkWell(
          onTap: _togglePasswordView,
          child: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => email.text = value!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
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
        hintText: "Entrer votre email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
