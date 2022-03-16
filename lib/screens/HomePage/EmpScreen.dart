import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/Screens/AddWork/AddWork.dart';
import 'package:login/screens/AddWork/UpdateDeleteWork.dart';
import 'WorkerInfos.dart';

final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

class EmpScreen extends StatelessWidget {
  static String nom = '';
  static String prenom = '';
  static String image = '';
  static String job = '';
  static String email = '';
  static String adress = '';
  static String nombre = '';
  static String price = '';
  static String time = '';
  static String description = '';
  static String availableDays = '';
  static String favorits = '';
  static String uid = '';
  static String somthing = '';
  static List<String> listFavorits = [];

  @override
  Widget build(BuildContext context) {
    //***** nta blast l id atdir l id dyal li 7al l app ********
    FirebaseFirestore.instance
        .collection('Utilisateur')
        .where("uid", isEqualTo: user!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        favorits = doc["favorits"];
        listFavorits = favorits.split(',');
        somthing = doc["Lastname"];
        //print("wow");
      });
    });
    return MyHomePage(user!.uid.toString());
  }
}

class MyHomePage extends StatefulWidget {
  final String nid;
  MyHomePage(this.nid);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? dt;

  @override
  Widget build(BuildContext context) {
    print('here');
    print(widget.nid);
    final Stream<QuerySnapshot> users = FirebaseFirestore.instance
        .collection('Utilisateur')
        .where('price', isNotEqualTo: -1)
        // .where('time', isEqualTo: 'Hour')
        .snapshots();

    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xEB1E1F69),
        child: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (dt?['price'] == -1) {
                return Icon(Icons.add, color: Colors.white);
              } else {
                return Icon(Icons.edit, color: Colors.white);
              }
            }),
        onPressed: () async {
          var collection = FirebaseFirestore.instance.collection('Utilisateur');
          var docSnapshot = await collection.doc(user!.uid).get();

          Map<String, dynamic>? data = docSnapshot.data();
          // var value = data?['job'];
          if (data?['price'] != -1 ||
              data?['job'] != "without" ||
              data?['description'] != "without") {
            Navigator.pushNamed(context, UpdateDeleteWork.routeName);
          } else {
            Navigator.pushNamed(context, AddWork.routeName);
          }
        },
      ),
      body: Center(
        child: ListView(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 4),
                  child: Text('Jobs'),
                ),
                Expanded(
                    child: Divider(
                  color: Color(0xEB1E1F69),
                  endIndent: 20,
                  indent: 10,
                )),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
              child: Container(
                child: SizedBox(
                  height: 100,
                  width: 90,
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: Center(child: Text('Here Job')),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 4),
                  child: Text('Explore'),
                ),
                Expanded(
                    child: Divider(
                  color: Color(0xEB1E1F69),
                  endIndent: 20,
                  indent: 10,
                )),
              ],
            ),
            Container(
                child: StreamBuilder<QuerySnapshot>(
              stream: users,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      CircularProgressIndicator(
                        color: Color(0xEB1E1F69),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text('Somethings went wrong ..'),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      CircularProgressIndicator(
                        color: Color(0xEB1E1F69),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text('Loading..'),
                    ],
                  );
                }

                final data = snapshot.requireData;

                return ListView.builder(
                  itemCount: data.size,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      //height: 120,
                      onTap: () {
                        EmpScreen.nom = data.docs[index]['Lastname'];
                        EmpScreen.prenom = data.docs[index]['Firstname'];
                        EmpScreen.image = data.docs[index]['image'];
                        EmpScreen.job = data.docs[index]['job'];
                        EmpScreen.adress = data.docs[index]['Adress'];
                        //MyApp.adress = snapshot.
                        EmpScreen.email = data.docs[index]['email'];
                        EmpScreen.price = data.docs[index]['price'].toString();
                        EmpScreen.time = data.docs[index]['time'];
                        EmpScreen.availableDays =
                            data.docs[index]['availableDays'];
                        EmpScreen.description = data.docs[index]['description'];
                        EmpScreen.nombre = data.docs[index]['nombre'];

                        EmpScreen.uid = data.docs[index]['uid'];
                        //print(MyApp.favorits+ '' MyApp.uid)
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Second()));
                      },
                      child: InkWell(
                        splashColor: Colors.amber,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ListTile(
                              leading: Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(data.docs[index]['image']),
                                  ),
                                ),
                              ),
                              title: Text(
                                '${data.docs[index]['Lastname']}  ${data.docs[index]['Firstname']}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                        size: 14,
                                      ),
                                      Text(
                                        '''${data.docs[index]['Adress']}  ''',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: Icon(
                                          Icons.engineering,
                                          color: Colors.grey,
                                          size: 14,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${data.docs[index]['job']}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: InkWell(
                                borderRadius: BorderRadius.circular(2),
                                splashColor: Color.fromARGB(235, 133, 135, 226),
                                child: Icon(
                                  (EmpScreen.listFavorits
                                          .contains(data.docs[index]['uid']))
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: (EmpScreen.listFavorits
                                          .contains(data.docs[index]['uid']))
                                      ? Color(0xEB1E1F69)
                                      : null,
                                ),
                                onTap: () {
                                  setState(() {
                                    if (!EmpScreen.listFavorits
                                        .contains(data.docs[index]['uid'])) {
                                      EmpScreen.listFavorits
                                          .add(data.docs[index]['uid']);
                                      var collection = FirebaseFirestore
                                          .instance
                                          .collection('Utilisateur');
                                      //****** Fblast doc dir l id dyal li dakhl l app daba ****
                                      collection
                                          .doc(
                                              'IqxSEw6ZYnWkEiWAqgwiO2kTs3i2') // <-- Doc ID where data should be updated.
                                          .update({
                                        'favorits':
                                            EmpScreen.listFavorits.join(',')
                                      });
                                    } else {
                                      EmpScreen.listFavorits
                                          .remove(data.docs[index]['uid']);
                                      var collection = FirebaseFirestore
                                          .instance
                                          .collection('Utilisateur');
                                      //****** Fblast doc dir l id dyal li dakhl l app daba ****
                                      collection
                                          .doc(
                                              'IqxSEw6ZYnWkEiWAqgwiO2kTs3i2') // <-- Doc ID where data should be updated.
                                          .update({
                                        'favorits':
                                            EmpScreen.listFavorits.join(',')
                                      });
                                    }
                                  });
                                },
                              ),
                              isThreeLine: true,
                            ),
                          ),
                        ),
                      ),
                    );
                    //return Text('My name is ${data.docs[index]['Firstname']}');
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  _fetch() async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    var collection = FirebaseFirestore.instance.collection('Utilisateur');
    var docSnapshot = await collection.doc(user!.uid).get();
    dt = docSnapshot.data();
  }
}
