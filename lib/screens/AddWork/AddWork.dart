// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/screens/HomePage/Homepage.dart';

class AddWork extends StatefulWidget {
  static String routeName = "/AddWork";

  @override
  _AddWorkState createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {
  final TextEditingController DescriptionCtrl = TextEditingController();
  final TextEditingController TimeCtrl = new TextEditingController();
  final TextEditingController PriceCtrl = new TextEditingController();

  Color TxtFieldcolor = Color(Colors.grey.value);

  List<String> DaysSelected = ['', '', '', '', '', '', ''];
  bool Sunday = false;
  bool Monday = false;
  bool Tuesday = false;
  bool Wednesday = false;
  bool Thursday = false;
  bool Friday = false;
  bool Saturday = false;
  String? time;
  String? selectedJob;
  bool _switchValue = true;
  String Fillallfields = '';
  Color cl = Colors.white;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(Color(0xEB1E1F69).value)),
          title: const Text(
            'Add work',
            style: TextStyle(
              color: Color(0xEB1E1F69),
            ),
          ),
          backgroundColor: Color(Colors.white.value),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 33),
                    child: Text(
                      "Your job",
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 295,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 105, 105, 105), width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                //Here the list of all services you can find in the app !
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedJob,
                    hint: Text('Select a job'),
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedJob = newValue;
                      });
                    },
                    //Here we give all the Jobs list ------------------------------->
                    items: <String>[
                      'Professor',
                      'Carpenter',
                      'Plumber',
                      'Mechanical',
                      'Smith',
                      'Chanteur'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 33),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Price/Time",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 33),
                    child: SizedBox(
                      width: 120,
                      height: 50,
                      child: TextField(
                        controller: PriceCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                          hintText: 'Price',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: Text('per'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: Container(
                      width: 120,
                      height: 50,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 105, 105, 105),
                            width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: time,
                          hint: Text('Time'),
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              time = newValue;
                            });
                          },
                          items: <String>['Hour', 'Day', 'Month']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 33),
                  child: Text(
                    "Description",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  margin: EdgeInsets.all(15),
                  height: 5 * 24.0,
                  child: TextField(
                    controller: DescriptionCtrl,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Description",
                      // filled: true,
                    ),
                  ),
                ),
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 33),
                  child: Text(
                    "Available Days",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 23),
                        child: ChoiceChip(
                          backgroundColor:
                              Color(Color.fromARGB(235, 68, 68, 68).value),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 247, 247, 247)),
                          selectedColor:
                              Color(Color.fromARGB(235, 62, 63, 145).value),
                          label: const Text('Sunday'),
                          selected: Sunday,
                          onSelected: (newValue) {
                            setState(() {
                              Sunday = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ChoiceChip(
                          backgroundColor:
                              Color(Color.fromARGB(235, 68, 68, 68).value),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 247, 247, 247)),
                          selectedColor:
                              Color(Color.fromARGB(235, 62, 63, 145).value),
                          label: const Text('Monday'),
                          selected: Monday,
                          onSelected: (newValue) {
                            setState(() {
                              Monday = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ChoiceChip(
                          backgroundColor:
                              Color(Color.fromARGB(235, 68, 68, 68).value),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 247, 247, 247)),
                          selectedColor:
                              Color(Color.fromARGB(235, 62, 63, 145).value),
                          label: const Text('Tuesday'),
                          selected: Tuesday,
                          onSelected: (newValue) {
                            setState(() {
                              Tuesday = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ChoiceChip(
                          backgroundColor:
                              Color(Color.fromARGB(235, 68, 68, 68).value),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 247, 247, 247)),
                          selectedColor:
                              Color(Color.fromARGB(235, 62, 63, 145).value),
                          label: const Text('Wednesday'),
                          selected: Wednesday,
                          onSelected: (newValue) {
                            setState(() {
                              Wednesday = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 70),
                        child: ChoiceChip(
                          backgroundColor:
                              Color(Color.fromARGB(235, 68, 68, 68).value),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 247, 247, 247)),
                          selectedColor:
                              Color(Color.fromARGB(235, 62, 63, 145).value),
                          label: const Text('Thursday'),
                          selected: Thursday,
                          onSelected: (newValue) {
                            setState(() {
                              Thursday = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ChoiceChip(
                          backgroundColor:
                              Color(Color.fromARGB(235, 68, 68, 68).value),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 247, 247, 247)),
                          selectedColor:
                              Color(Color.fromARGB(235, 62, 63, 145).value),
                          label: const Text('Friday'),
                          selected: Friday,
                          onSelected: (newValue) {
                            setState(() {
                              Friday = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ChoiceChip(
                          backgroundColor:
                              Color(Color.fromARGB(235, 68, 68, 68).value),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 247, 247, 247)),
                          selectedColor:
                              Color(Color.fromARGB(235, 62, 63, 145).value),
                          label: const Text('Saturday'),
                          selected: Saturday,
                          onSelected: (newValue) {
                            setState(() {
                              Saturday = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 33),
                      child: Text(
                        "Show my profile",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 155,
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: _switchValue,
                      activeColor: Color(0xEB1E1F69),
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 28,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: cl,
                    ),
                    Text(
                      Fillallfields,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  child: const Text('Post'),
                  onPressed: () {
                    DaysSelected[0] = tests(Monday, 'Monday');
                    DaysSelected[1] = tests(Tuesday, 'Tuesday');
                    DaysSelected[2] = tests(Wednesday, 'Wednesday');
                    DaysSelected[3] = tests(Thursday, 'Thursday');
                    DaysSelected[4] = tests(Friday, 'Friday');
                    DaysSelected[5] = tests(Saturday, 'Saturday');
                    DaysSelected[6] = tests(Sunday, 'Sunday');

                    if (selectedJob != null &&
                        PriceCtrl.text.isNotEmpty &&
                        time != null &&
                        DescriptionCtrl.text.isNotEmpty &&
                        (DaysSelected.contains('Monday') ||
                            DaysSelected.contains('Tuesday') ||
                            DaysSelected.contains('Wednesday') ||
                            DaysSelected.contains('Thursday') ||
                            DaysSelected.contains('Friday') ||
                            DaysSelected.contains('Saturday') ||
                            DaysSelected.contains('Sunday'))) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          // title: const Text('Post'),
                          content: const Text(
                              'Are you sure you want to post this job offer '),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'No');
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                //TO-DO: Here all the processing to transfer to DATABASE

                                await firebaseFirestore
                                    .collection("Utilisateur")
                                    .doc(user!.uid)
                                    .update({
                                  'price': PriceCtrl.text,
                                  'job': selectedJob,
                                  'description': DescriptionCtrl.text,
                                  'availableDays': DaysSelected[0] +
                                      '-' +
                                      DaysSelected[1] +
                                      '-' +
                                      DaysSelected[2] +
                                      '-' +
                                      DaysSelected[3] +
                                      '-' +
                                      DaysSelected[4] +
                                      '-' +
                                      DaysSelected[5] +
                                      '-' +
                                      DaysSelected[6],
                                  'time': time
                                });
                                Navigator.pushNamed(
                                    context, HomePage.routeName);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      setState(() {
                        Fillallfields = 'You have to fill all the fields!! ';
                        cl = Colors.red;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(Color(0xEB1E1F69).value),
                    //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    // textStyle: TextStyle(fontSize: 20)
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

String tests(bool a, String str) {
  if (a) {
    return str;
  } else {
    return '';
  }
}
