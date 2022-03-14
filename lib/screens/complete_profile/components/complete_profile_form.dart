import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:login/components/default_button.dart';
import 'package:login/components/form_error.dart';
import 'package:login/screens/HomePage/Homepage.dart';
import 'package:login/screens/constants.dart';
import 'package:login/screens/size_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../model.dart';

class CompleteProfileForm extends StatefulWidget {
  final String email;
  final String password;
  CompleteProfileForm({Key? key, required this.email, required this.password})
      : super(key: key);
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  File? _image;
  String? path;
  String? job = "Chanteur";
  String? localisation = "Agadir";
  String? username;
  String? age;
  final _auth = FirebaseAuth.instance;
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

  _imgFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imagetmp = File(image.path);
    setState(() {
      this._image = imagetmp;
    });
  }

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
          Center(
              child: Text("Chose a picture ",
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(235, 0, 0, 0)))),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xEB1E1F69),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAgeFormField(),
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
                        12), //border raiuds of dropdown button
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 36, right: 30, top: 5),
                    child: buildlocalisationBox(),
                  ))),
          SizedBox(height: getProportionateScreenHeight(35)),
          FormError(errors: errors),
          SizedBox(
            height: 5,
          ),
          DefaultButton(
            text: "Next",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.pushNamed(context, HomePage.routeName);
                await _auth
                    .createUserWithEmailAndPassword(
                        email: widget.email, password: widget.password)
                    .then((value) => {postDetailsToFirestore()});
              }
            },
          ),
        ],
      ),
    );
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
      value: localisation,
      elevation: 16,
      isExpanded: true,
      underline: SizedBox(),
      style: const TextStyle(color: Color.fromARGB(235, 0, 0, 0), fontSize: 17),
      onChanged: (String? newValue) {
        setState(() {
          localisation = newValue!;
        });
      },
      items: <String>[
        "Casablanca",
        "Fez",
        "Tangier",
        "Marrakesh",
        "Salé",
        "Meknes",
        "Rabat",
        "Oujda",
        "Kenitra",
        "Agadir",
        "Tetouan",
        "Temara",
        "Safi",
        "Mohammedia",
        "Khouribga",
        "El Jadida",
        "Beni Mellal",
        "Ait Melloul",
        "Nador",
        "Dar Bouazza",
        "Taza",
        "Settat",
        "Berrechid",
        "Khemisset",
        "Inezgane",
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
      onSaved: (newValue) => phoneNumber = newValue,
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
          borderRadius: new BorderRadius.circular(12),
        ),
        labelText: "Phone",
        hintText: "Enter your phone",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Color(0xEB1E1F69),
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xEB1E1F69)),
          borderRadius: new BorderRadius.circular(12),
        ),
        labelText: "Last name",
        hintText: "Enter your last name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAgeFormField() {
    return TextFormField(
      onSaved: (newValue) => age = newValue,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Color(0xEB1E1F69),
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xEB1E1F69)),
          borderRadius: new BorderRadius.circular(12),
        ),
        labelText: "Age",
        hintText: "Enter your age",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
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
          borderRadius: new BorderRadius.circular(12),
        ),
        labelText: "First name",
        hintText: "Enter Your first name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Future<String> _uploadphotofile(imgfile) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Users_images");
    UploadTask uploadTask =
        storageReference.child("$firstName" "_$lastName.jpg").putFile(imgfile);

    String url = await (await uploadTask).ref.getDownloadURL();

    print(url);
    return url;
  }

/*
  uploadImagetFirebase(String imagePath) async {
    await FirebaseStorage.instance
        .ref(imagePath)
        .putFile(File(imagePath))
        .then((taskSnapshot) {
      print("task done");

// download url when it is uploaded
      if (taskSnapshot.state == TaskState.success) {
        FirebaseStorage.instance.ref(imagePath).getDownloadURL().then((url) {
          link = url;
          print("Here is the URL of Image $link");
          return url;
        }).catchError((onError) {
          print("Got Error $onError");
        });
      }
    });
  }*/

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    String url = await _uploadphotofile(_image);
    // writing all the values
    String n = user!.email!.replaceAll("@gmail.com", "");
    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.password = widget.password;
    userModel.Firstname = firstName;
    userModel.Lastname = lastName;
    userModel.nombre = phoneNumber;
    userModel.image = url;
    userModel.Adress = address;
    userModel.job = "without";
    userModel.description = "without";
    userModel.Adress = localisation;
    userModel.username = n;
    userModel.price = -1;
    userModel.age = "19";
    await firebaseFirestore
        .collection("Utilisateur")
        .doc(user.uid)
        .set(userModel.toMap());
/* Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (route) => false);*/
  }
}
