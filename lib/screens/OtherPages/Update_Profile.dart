import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login/components/default_button.dart';
import 'package:login/components/form_error.dart';
import 'package:login/screens/HomePage/Homepage.dart';
import 'package:login/screens/constants.dart';
import 'package:login/screens/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model.dart';

class Updatescreen extends StatelessWidget {
//  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xEB1E1F69),
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 255, 255, 255), //change your color here
        ),
      ),
      body: Body(),
    );
  }
}

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController address = new TextEditingController();
  File? _image;
  int i = 0;
  String? path;
  TextEditingController job = new TextEditingController();

  TextEditingController localisation =
      new TextEditingController(text: 'Agadir');
  TextEditingController age = new TextEditingController();
  TextEditingController pic = new TextEditingController();
  TextEditingController oldpic = new TextEditingController();
  TextEditingController description = new TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Utilisateur")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      pic.text = loggedInUser.image.toString();
      oldpic.text = loggedInUser.image.toString();
      localisation.text = loggedInUser.Adress.toString();
      firstName.text = loggedInUser.Firstname.toString();
      lastName.text = loggedInUser.Lastname.toString();
      job.text = loggedInUser.job.toString();
      email.text = loggedInUser.email.toString();
      password.text = loggedInUser.password.toString();
      age.text = loggedInUser.age.toString();
      phoneNumber.text = loggedInUser.nombre.toString();
      description.text = loggedInUser.description.toString();
      // price = loggedInUser.price;
      setState(() {});
    });
  }

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  Future<String> _uploadphotofile(imgfile) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Users_images");
    UploadTask uploadTask =
        storageReference.child("$firstName" "$lastName.jpg").putFile(imgfile);

    String url = await (await uploadTask).ref.getDownloadURL();
    print(url);
    return url;
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
      child: Column(
        children: [
          SizedBox(
            height: 9,
          ),
          Container(
            child: Text(
              "Edit Profile",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
              child: Stack(children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 4,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Color.fromARGB(255, 58, 56, 56).withOpacity(0.1),
                        offset: Offset(0, 10))
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(pic.text))),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                  onTap: () async {
                    _showPicker(context);
                    pic.text = await _uploadphotofile(_image);
                    print(oldpic.text);
                    String filePath = oldpic.text
                        .replaceAll(
                            new RegExp(
                                'https://firebasestorage.googleapis.com/v0/b/employe-8f42c.appspot.com/o/Users_images%2F'),
                            '')
                        .split('?')[0];
                    FirebaseStorage.instance
                        .ref()
                        .child(filePath)
                        .delete()
                        .then((_) => print(
                            'Successfully deleted $filePath storage item'));
                    // FirebaseStorage.instance.refFromURL(oldpic.text).delete();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      color: Color(0xEB1E1F69),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  )),
            )
          ])),
          SizedBox(height: getProportionateScreenHeight(30)),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Personal Informations :",
                style: TextStyle(
                    color: Color.fromARGB(255, 82, 79, 79),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAgeFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          SizedBox(
              width: 380,
              height: 60,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255,
                        255), //background color of dropdown button
                    border: Border.all(
                        color: Color(0xEB1E1F69),
                        width: 2), //border of dropdown button
                    borderRadius: BorderRadius.circular(
                        25.0), //border raiuds of dropdown button
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 36, right: 30, top: 5),
                    child: buildlocalisationBox(),
                  ))),
          /*SizedBox(height: getProportionateScreenHeight(30)),
          buildPriceFormField(),*/
          SizedBox(height: getProportionateScreenHeight(30)),
          buildocuupationFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          builddescriptionFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Security Informations :",
                style: TextStyle(
                    color: Color.fromARGB(255, 82, 79, 79),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
          SizedBox(height: getProportionateScreenHeight(40)),
          buildEmailFormField(),
          SizedBox(height: 30),
          buildPasswordFormField(),
          FormError(errors: errors),
          SizedBox(height: 40),
          DefaultButton(
              text: "Continue",
              press: () async {
                User? user1 = _auth.currentUser;
                await firebaseFirestore
                    .collection("Utilisateur")
                    .doc(user1!.uid)
                    .update(
                  {
                    'Firstname': firstName.text,
                    'Lastname': lastName.text,
                    'nombre': phoneNumber.text,
                    'job': job.text,
                    'description': description.text,
                    'Adress': localisation.text,
                    'age': age.text,
                    'image': pic.text,
                  },
                );
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AdvanceCustomAlertt();
                    });
              }),
        ],
      ),
    );
  }

  _imgFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imagetmp = File(image.path);
    setState(() {
      this._image = imagetmp;
    });
  }

  late Future<String> link;
  _imgFromCamera() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;
    final imagetmp = File(image.path);
    setState(() {
      this._image = imagetmp;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      //leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    // leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  DropdownButton buildlocalisationBox() {
    return DropdownButton<String>(
      value: localisation.text,
      elevation: 16,
      style: const TextStyle(color: Color.fromARGB(235, 0, 0, 0), fontSize: 17),
      onChanged: (String? newValue) {
        setState(() {
          // localisation = newValue!;
        });
      },
      items: <String>[
        'Agadir',
        'Casablanca',
        'Kenitra',
        'Sale',
        'Tanger',
        'Marrakech',
        'Laayoune',
      ].map<DropdownMenuItem<String>>((String valuea) {
        return DropdownMenuItem<String>(
          value: valuea,
          child: Text(valuea),
        );
      }).toList(),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneNumber,
      onSaved: (newValue) => phoneNumber.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
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
        labelText: "Numéro de téléphone",
        hintText: "Entrer votre numéro de téléphone",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      controller: lastName,
      onSaved: (newValue) => lastName.text = newValue!,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Color(0xEB1E1F69),
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xEB1E1F69)),
          borderRadius: new BorderRadius.circular(25.0),
        ),
        labelText: "Nom",
        hintText: "Enter your first name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAgeFormField() {
    return TextFormField(
      controller: age,
      onSaved: (newValue) => age.text = newValue!,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Color(0xEB1E1F69),
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xEB1E1F69)),
          borderRadius: new BorderRadius.circular(25.0),
        ),
        labelText: "Age",
        hintText: "Enter your Age",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      controller: firstName,
      onSaved: (newValue) => firstName.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
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
        labelText: "First name",
        hintText: "Enter your first name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField builddescriptionFormField() {
    return TextFormField(
      controller: description,
      onSaved: (newValue) => description.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
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
        labelText: "Description",
        hintText: "Entrer votre blabla",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildocuupationFormField() {
    return TextFormField(
      controller: job,
      onSaved: (newValue) => job.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
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
        labelText: "Job",
        hintText: "Entrer votre Job",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: password,
      //obscureText: true,
      enabled: false,
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
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: email,
      enabled: false,
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
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(children: [
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                UpdatePage(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        ),
      ),
    ]));
  }
}

class AdvanceCustomAlertt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 220,
              width: 450,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Done!!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Your profile informations changed',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Color(0xEB1E1F69),
                      child: Text(
                        'Go',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -60,
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 10, 133, 26),
                  radius: 60,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                )),
          ],
        ));
  }
}
