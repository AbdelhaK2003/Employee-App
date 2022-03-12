import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model.dart';
import '../HomePage/Homepage.dart';
import 'FunctionsUpDe.dart';

class UpdateDeleteWork extends StatefulWidget {
  static String routeName = "/UpdateDeleteWork";

  @override
  State<UpdateDeleteWork> createState() => _UpdateDeleteWorkState();
}

class _UpdateDeleteWorkState extends State<UpdateDeleteWork> {
  final TextEditingController DescriptionCtrl = TextEditingController();
  TextEditingController TimeCtrl = new TextEditingController();
  TextEditingController PriceCtrl = new TextEditingController();
  //variables for fields
  String? selectedJob;
  String? time;
  bool Sunday = false;
  bool Monday = false;
  bool Tuesday = false;
  bool Wednesday = false;
  bool Thursday = false;
  bool Friday = false;
  bool Saturday = false;
  //Var for data from DATABASE
  Map<String, dynamic>? data;
  //vars for days
  String Daychars = '';
  String Day = '';
  List<String> DaysSelected = ['', '', '', '', '', '', ''];
  //var for showing photo
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel loggedInUser = UserModel();
    final _auth = FirebaseAuth.instance;

    FirebaseFirestore.instance
        .collection("Utilisateur")
        .doc(user!.uid)
        .get()
        .then((value) {});
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xEB1E1F69),
      ),
      body: Container(
        child: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              //variables for use in this widgets
              selectedJob = data?['job'];
              time = data?['time'];
              var pr = data?['price'];
              PriceCtrl.text = '$pr' + ' ';
              DescriptionCtrl.text = data?['description'];
              String a = data?['availableDays'];
              //---------------------------------------------------
              if (snapshot.connectionState != ConnectionState.done)
                return Center(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(Color(0xEB1E1F69).value),
                        ),
                        Text('Laoding...'),
                      ],
                    ),
                  ),
                );
              for (int i = 0; i < a.length; i++) {
                if (a[i] == '-') {
                  print('days chars here');
                  switch (Daychars) {
                    case 'Monday':
                      //  DaysSelected[0] = 'Monday';
                      Monday = true;
                      Daychars = '';
                      break;
                    case 'Tuesday':
                      //DaysSelected[1] = 'Tuesday';
                      Tuesday = true;
                      Daychars = '';
                      break;
                    case 'Wednesday':
                      //DaysSelected[2] = 'Wednesday';
                      Wednesday = true;
                      Daychars = '';
                      break;
                    case 'Thursday':
                      //DaysSelected[3] = 'Thursday';
                      Thursday = true;
                      Daychars = '';
                      break;
                    case 'Friday':
                      //DaysSelected[4] = 'Friday';
                      Friday = true;
                      Daychars = '';
                      break;
                    case 'Saturday':
                      //DaysSelected[5] = 'Saturday';
                      Saturday = true;
                      Daychars = '';
                      break;
                    case 'Sunday':
                      //DaysSelected[6] = 'Sunday';
                      Sunday = true;
                      Daychars = '';
                      break;
                    default:
                  }
                } else {
                  Daychars = Daychars + a[i];
                }
              }
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xEB1E1F69),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      data?['image']),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 200),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        "Show my profile",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
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
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      al('Job '),
                      WorkEdit('Job', data?['job'], () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('Job'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: 295,
                                          height: 55,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 105, 105, 105),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          //Here the list of all services you can find in the app !
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedJob,
                                              //hint: Text('Select a job'),
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              elevation: 16,
                                              isExpanded: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedJob = newValue;
                                                  print(selectedJob);
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
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Edit'),
                                      onPressed: () async {
                                        await firebaseFirestore
                                            .collection("Utilisateur")
                                            .doc(user.uid)
                                            .update({
                                          'job': selectedJob,
                                        });

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      al('Price/Time '),
                      WorkEdit('Price/Time', '$pr' + ' / ' + time!, () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text('Price/Time'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              height: 50,
                                              child: TextField(
                                                controller: PriceCtrl,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.teal),
                                                  ),
                                                  hintText: 'Price',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 120,
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 105, 105, 105),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: time,
                                                  hint: Text('Time'),
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  elevation: 16,
                                                  isExpanded: true,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      time = newValue;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Hour',
                                                    'Day',
                                                    'Month'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Edit'),
                                      onPressed: () async {
                                        await firebaseFirestore
                                            .collection("Utilisateur")
                                            .doc(user.uid)
                                            .update({
                                          'price': PriceCtrl.text,
                                          'time': time
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      al('Desciption '),
                      WorkEdit('Desciption', data?['description'], () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text('Desciption'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
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
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Edit'),
                                      onPressed: () async {
                                        await firebaseFirestore
                                            .collection("Utilisateur")
                                            .doc(user.uid)
                                            .update({
                                          'description': DescriptionCtrl.text,
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      al('Days '),
                      ListTile(
                          minLeadingWidth: 30,
                          title: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      day(Sunday, EdgeInsets.only(left: 40),
                                          'Sunday'),
                                      day(Monday, EdgeInsets.only(left: 2),
                                          'Monday'),
                                      day(Tuesday, EdgeInsets.only(left: 2),
                                          'Tuesday'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      day(Wednesday, EdgeInsets.only(left: 40),
                                          'Wednesday'),
                                      day(Thursday, EdgeInsets.only(left: 5),
                                          'Thursday'),
                                      day(Friday, EdgeInsets.only(left: 5),
                                          'Friday'),
                                    ],
                                  ),
                                  day(Saturday, EdgeInsets.only(left: 30),
                                      'Saturday'),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.grey[600],
                                  )),
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Days'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Column(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    day2(
                                                      'Sunday',
                                                      Sunday,
                                                      EdgeInsets.only(left: 10),
                                                      (newValue) {
                                                        setState(() {
                                                          Sunday = newValue;
                                                        });
                                                      },
                                                    ),
                                                    day2(
                                                      'Monday',
                                                      Monday,
                                                      EdgeInsets.only(left: 2),
                                                      (newValue) {
                                                        setState(() {
                                                          Monday = newValue;
                                                        });
                                                      },
                                                    ),
                                                    day2(
                                                      'Tuesday',
                                                      Tuesday,
                                                      EdgeInsets.only(left: 2),
                                                      (newValue) {
                                                        setState(() {
                                                          Tuesday = newValue;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    day2(
                                                      'Wednesday',
                                                      Wednesday,
                                                      EdgeInsets.only(left: 0),
                                                      (newValue) {
                                                        setState(() {
                                                          Wednesday = newValue;
                                                        });
                                                      },
                                                    ),
                                                    day2(
                                                      'Thursday',
                                                      Thursday,
                                                      EdgeInsets.only(left: 2),
                                                      (newValue) {
                                                        setState(() {
                                                          Thursday = newValue;
                                                        });
                                                      },
                                                    ),
                                                    day2(
                                                      'Friday',
                                                      Friday,
                                                      EdgeInsets.only(left: 2),
                                                      (newValue) {
                                                        setState(() {
                                                          Friday = newValue;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                day2(
                                                  'Saturday',
                                                  Saturday,
                                                  EdgeInsets.only(left: 0),
                                                  (newValue) {
                                                    setState(() {
                                                      Saturday = newValue;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Edit'),
                                          onPressed: () async {
                                            DaysSelected[0] =
                                                tests(Monday, 'Monday');
                                            DaysSelected[1] =
                                                tests(Tuesday, 'Tuesday');
                                            DaysSelected[2] =
                                                tests(Wednesday, 'Wednesday');
                                            DaysSelected[3] =
                                                tests(Thursday, 'Thursday');
                                            DaysSelected[4] =
                                                tests(Friday, 'Friday');
                                            DaysSelected[5] =
                                                tests(Saturday, 'Saturday');
                                            DaysSelected[6] =
                                                tests(Sunday, 'Sunday');
                                            await firebaseFirestore
                                                .collection("Utilisateur")
                                                .doc(user.uid)
                                                .update({
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
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          }),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    // title: const Text('Post'),
                                    content: const Text(
                                        'Are you sure you want to Delete your job offer !'),
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
                                              .doc(user.uid)
                                              .update({
                                            'price': -1,
                                            'job': 'without',
                                            'description': 'without',
                                            'availableDays': 'without',
                                            'time': 'without',
                                          });

                                          Navigator.pushNamed(
                                              context, HomePage.routeName);
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Color(0xEB1E1F69),
                                  ),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Color(0xEB1E1F69)),
                                  ),
                                ],
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(
                                              color: Color(0xEB1E1F69)))))),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  _fetch() async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    var collection = FirebaseFirestore.instance.collection('Utilisateur');
    var docSnapshot = await collection.doc(user!.uid).get();
    data = docSnapshot.data();
  }

  String tests(bool a, String str) {
    if (a) {
      return str;
    } else {
      return '';
    }
  }
}
