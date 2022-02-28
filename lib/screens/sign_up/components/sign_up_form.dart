import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/custom_surfix_icon.dart';
import 'package:login/components/default_button.dart';
import 'package:login/components/form_error.dart';
import 'package:login/model.dart';
import 'package:login/screens/complete_profile/complete_profile_screen.dart';
import 'package:login/screens/constants.dart';
import 'package:login/screens/sign_in/sign_in_screen.dart';
import 'package:login/screens/size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final email = new TextEditingController();
  final password = new TextEditingController();
  final confirmPassword = new TextEditingController();

  bool remember = false;
  final List<String?> errors = [];

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
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
              text: "Continue",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompleteProfileScreen(
                        email: email.text,
                        password: password.text,
                      ),
                    ));
              } /*async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                print(email.text);
                Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                await _auth
                    .createUserWithEmailAndPassword(
                        email: email.text, password: password.text)
                    .then((value) => {postDetailsToFirestore()});
              }
            },*/
              ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      controller: confirmPassword,
      //obscureText: true,
      onSaved: (newValue) => confirmPassword.text = newValue!,
      /*onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (password.text != confirmPassword.text) {
          removeError(error: kMatchPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },*/
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Color(0xEB1E1F69),
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xEB1E1F69)),
          borderRadius: new BorderRadius.circular(25.0),
        ),
        labelText: "Confirmer Mot de passe",
        hintText: "Re-Entrer votre mot de passe",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/lock-.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: password,
      //obscureText: true,
      onSaved: (newValue) => password.text = newValue!,
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
        labelText: "Mot de passe",
        hintText: "Entrer votre mot de passe",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/lock-.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email.text = newValue!,
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
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/mail-.svg"),
      ),
    );
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.password = password.text;
    await firebaseFirestore
        .collection("Users")
        .doc(user.uid)
        .set(userModel.toMap());
/*
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (route) => false);*/
  }
}
