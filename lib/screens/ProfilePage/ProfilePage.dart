import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/OtherPages/SettingPage.dart';

import '../../model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  getMyInfoFromSharedPreference() async {
    FirebaseFirestore.instance
        .collection("Utilisateur")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    });
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  get borderRadius => BorderRadius.circular(8.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 450,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
              )
            ],
          ),
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  loggedInUser.Firstname.toString() +
                      " " +
                      loggedInUser.Lastname.toString(),
                  style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  loggedInUser.job.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1.2,
                    color: Color.fromARGB(255, 177, 169, 169),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 3.8,
                height: MediaQuery.of(context).size.width / 3.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xEB1E1F69), width: 4),
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 197, 197, 197),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(loggedInUser.image.toString()),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(
                      Icons.circle_sharp,
                      color: Color.fromARGB(235, 8, 138, 25),
                      size: 15,
                    ),
                    Text(
                      " Active",
                      style: TextStyle(
                        color: Color.fromARGB(255, 15, 15, 15),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ]),
                ],
              ),
              SizedBox(
                height: 17,
              ),
              Container(
                  child: Row(
                children: [
                  Text("   "),
                  Icon(Icons.place, color: Color(0xEB1E1F69)),
                  Text(
                    " " + loggedInUser.Adress! + " ",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Icon(Icons.watch_later, color: Color(0xEB1E1F69)),
                  Text(
                    "  05 Mars",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerRight,
                    child: Material(
                      elevation: 10,
                      borderRadius: borderRadius,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(0.0),
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                          ),
                          child: Row(
                            children: <Widget>[
                              LayoutBuilder(builder: (context, constraints) {
                                return Container(
                                  height: constraints.maxHeight,
                                  width: constraints.maxHeight,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(235, 48, 49, 136),
                                    borderRadius: borderRadius,
                                  ),
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                      label: Text(
                    'Phone :',
                    style: TextStyle(
                        color: Color(0xFF464444),
                        fontStyle: FontStyle.normal,
                        fontSize: 17),
                  )),
                  DataColumn(
                    label: Text(
                      '',
                      style: TextStyle(fontStyle: FontStyle.normal),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                      style: TextStyle(fontStyle: FontStyle.normal),
                    ),
                  ),
                  DataColumn(
                      label: Text(
                    loggedInUser.nombre!,
                    style: TextStyle(
                        color: Color.fromARGB(223, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
                ],
                rows: <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                        'Age :',
                        style: TextStyle(
                            color: Color(0xFF464444),
                            fontStyle: FontStyle.normal,
                            fontSize: 17),
                      )),
                      DataCell(Text('   ')),
                      DataCell(Text('   ')),
                      DataCell(Text(
                        "20 Ans",
                        style: TextStyle(
                            color: Color.fromARGB(223, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                        'Price :',
                        style: TextStyle(
                            color: Color(0xFF464444),
                            fontStyle: FontStyle.normal,
                            fontSize: 17),
                      )),
                      DataCell(Text('   ')),
                      DataCell(Text('   ')),
                      DataCell(Text(
                        loggedInUser.price.toString() + " Dh",
                        style: TextStyle(
                            color: Color.fromARGB(223, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 16),
                      )),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                        'Time :',
                        style: TextStyle(
                            color: Color(0xFF464444),
                            fontStyle: FontStyle.normal,
                            fontSize: 17),
                      )),
                      DataCell(Text('   ')),
                      DataCell(Text('   ')),
                      DataCell(Text(
                        "All Days",
                        style: TextStyle(
                            color: Color.fromARGB(223, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 16),
                      )),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                        'Description: ',
                        style: TextStyle(
                            color: Color(0xFF464444),
                            fontStyle: FontStyle.normal,
                            fontSize: 17),
                      )),
                      DataCell(Text('   ')),
                      DataCell(Text('   ')),
                      DataCell(Text(
                        "",
                      )),
                    ],
                  ),
                ],
              )),
              Container(
                child: Text(loggedInUser.description!,
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xEB1E1F69);
    Path path = Path()
      ..relativeLineTo(0, 130)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 130)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
