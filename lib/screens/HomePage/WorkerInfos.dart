import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:login/Screens/Chat_Screen/chatscreen.dart';

import '../../model.dart';
import '../AddWork/FunctionsUpDe.dart';
import 'EmpScreen.dart';

class Second extends StatefulWidget {
  static String routeName = "/InofDet";
  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  String Daychars = '';
  bool Sunday = false;
  bool Monday = false;
  bool Tuesday = false;
  bool Wednesday = false;
  bool Thursday = false;
  bool Friday = false;
  bool Saturday = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      String a = EmpScreen.availableDays;
      //---------------------------------------------------
      if (snapshot.connectionState == ConnectionState.waiting)
        return Scaffold(
          body: Center(
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
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xEB1E1F69),
          iconTheme: IconThemeData(
            color: Color(Colors.white.value),
          ),
          title: Center(
            child: Text('Details'),
          ),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Color(0xEB1E1F69),
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: Icon(Icons.chat),
                onTap: () {
                  final _auth = FirebaseAuth.instance;
                  User? user = _auth.currentUser;
                  var chatRoomId = getChatRoomIdByUsernames(
                      EmpScreen.email.replaceAll("@gmail.com", ""),
                      user!.email!.replaceAll("@gmail.com", ""));
                  Map<String, dynamic> chatRoomInfoMap = {
                    "Utilisateur": [
                      EmpScreen.email.replaceAll("@gmail.com", ""),
                      user.email!.replaceAll("@gmail.com", "")
                    ]
                  };
                  UserModel().createChatRoom(chatRoomId, chatRoomInfoMap);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              EmpScreen.email.replaceAll("@gmail.com", ""),
                              EmpScreen.prenom,
                              EmpScreen.nom,
                              EmpScreen.image)));
                }
                // label: 'Contact',
                ),
            SpeedDialChild(
                child: Icon(
                  (EmpScreen.listFavorits.contains(EmpScreen.uid))
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: (EmpScreen.listFavorits.contains(EmpScreen.uid))
                      ? Color(0xEB1E1F69)
                      : null,
                  size: 30.0,
                ),
                onTap: () {
                  setState(() {
                    if (!EmpScreen.listFavorits.contains(EmpScreen.uid)) {
                      EmpScreen.listFavorits.add(EmpScreen.uid);
                      var collection =
                          FirebaseFirestore.instance.collection('Utilisateur');
                      //****** Fblast doc dir l id dyal li dakhl l app daba ****
                      collection
                          .doc(
                              'IqxSEw6ZYnWkEiWAqgwiO2kTs3i2') // <-- Doc ID where data should be updated.
                          .update(
                              {'favorits': EmpScreen.listFavorits.join(',')});
                    } else {
                      EmpScreen.listFavorits.remove(EmpScreen.uid);
                      var collection =
                          FirebaseFirestore.instance.collection('Utilisateur');
                      //****** Fblast doc dir l id dyal li dakhl l app daba ****
                      collection
                          .doc(
                              'IqxSEw6ZYnWkEiWAqgwiO2kTs3i2') // <-- Doc ID where data should be updated.
                          .update(
                              {'favorits': EmpScreen.listFavorits.join(',')});
                    }
                  });
                }
                //label: 'Add to favorite',
                )
          ],
        ),
        body: ListView(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(0),
                bottomLeft: Radius.circular(70),
              ),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xEB1E1F69), Color(0xEB1E1F69)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.5, 0.9],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 19, top: 35, right: 12, bottom: 15),
                        child: SizedBox(
                          height: 95,
                          width: 95,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            minRadius: 85.0,
                            child: CircleAvatar(
                              radius: 80.0,
                              backgroundImage: NetworkImage(EmpScreen.image),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 9),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            children: [
                              Text(
                                EmpScreen.prenom,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                EmpScreen.nom,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Align(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, bottom: 12),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.engineering,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                          EmpScreen.job,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                          EmpScreen.adress,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 4),
                        child: Text('About me'),
                      ),
                      Expanded(
                          child: Divider(
                        color: Color(0xEB1E1F69),
                        endIndent: 20,
                        indent: 10,
                      )),
                    ],
                  ),
                  ListTile(
                    subtitle: Expanded(
                      child: Text(
                        EmpScreen.description,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 4),
                        child: Text('Informations'),
                      ),
                      Expanded(
                          child: Divider(
                        color: Color(0xEB1E1F69),
                        endIndent: 20,
                        indent: 10,
                      )),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    onTap: () {},
                    title: Text(
                      'Telephone',
                      style: TextStyle(
                        color: Color(0xEB1E1F69),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      EmpScreen.nombre,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Color(0xEB1E1F69),
                    endIndent: 20,
                    indent: 20,
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.email),
                    title: Text(
                      'Email',
                      style: TextStyle(
                        color: Color(0xEB1E1F69),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      EmpScreen.email,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Color(0xEB1E1F69),
                    endIndent: 20,
                    indent: 20,
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.payments),
                    title: Text(
                      'Price / Time',
                      style: TextStyle(
                        color: Color(0xEB1E1F69),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      EmpScreen.price.toString() + ' DH Per  ' + EmpScreen.time,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Color(0xEB1E1F69),
                    endIndent: 20,
                    indent: 20,
                  ),
                  ListTile(
                    minLeadingWidth: 30,
                    title: Text(
                      'Available days',
                      style: TextStyle(
                        color: Color(0xEB1E1F69),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                day(Sunday, EdgeInsets.only(left: 10),
                                    'Sunday'),
                                day(Monday, EdgeInsets.only(left: 2), 'Monday'),
                                day(Tuesday, EdgeInsets.only(left: 2),
                                    'Tuesday'),
                                day(Wednesday, EdgeInsets.only(left: 2),
                                    'Wednesday'),
                              ],
                            ),
                            Row(
                              children: [
                                day(Thursday, EdgeInsets.only(left: 5),
                                    'Thursday'),
                                day(Friday, EdgeInsets.only(left: 5), 'Friday'),
                                day(Saturday, EdgeInsets.only(left: 5),
                                    'Saturday'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
