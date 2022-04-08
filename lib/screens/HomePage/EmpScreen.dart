import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/Screens/AddWork/AddWork.dart';
import 'package:login/model.dart';
import 'package:login/screens/AddWork/UpdateDeleteWork.dart';
import 'WorkerInfos.dart';

final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

import '../Chat_Screen/chatscreen.dart';

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
<<<<<<< HEAD

class Second extends StatefulWidget {
  static String routeName = "/InofDet";
  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xEB1E1F69),
        title: Center(
          child: Text(EmpScreen.nom + ' ' + EmpScreen.prenom),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.5, 0.9],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      /*  CircleAvatar(
                        backgroundColor: Colors.red.shade300,
                        minRadius: 35.0,
                        child: Icon(
                          Icons.call,
                          size: 30.0,
                        ),
                      ),*/

                      CircleAvatar(
                        backgroundColor: Colors.white,
                        minRadius: 85.0,
                        child: CircleAvatar(
                          radius: 80.0,
                          backgroundImage: NetworkImage(EmpScreen.image),
                        ),
                      ),
                      /*
                      CircleAvatar(
                        backgroundColor: Colors.red.shade300,
                        minRadius: 35.0,
                        child: Icon(
                          Icons.message,
                          size: 30.0,
                        ),
                      ),*/
                    ],
                  ),
                  SizedBox(
                    child: Container(
                      //color: Colors.red,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.blue.shade300],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.5, 0.9],
                        ),
                      ),
                    ),
                    height: 10,
                  ),
                  Text(
                    EmpScreen.nom + ' ' + EmpScreen.prenom,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    EmpScreen.job,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 10.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.5, 0.9],
              ),
            ),
          ),
          Container(
            height: 20.0,
            color: Colors.blue,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: GestureDetector(
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
                                    EmpScreen.email
                                        .replaceAll("@gmail.com", ""),
                                    EmpScreen.prenom,
                                    EmpScreen.nom,
                                    EmpScreen.image)));
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        minRadius: 35.0,
                        child: Icon(
                          Icons.message,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      color: Colors.blue,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        minRadius: 35.0,
                        child: Icon(
                          (EmpScreen.listFavorits.contains(EmpScreen.uid))
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              (EmpScreen.listFavorits.contains(EmpScreen.uid))
                                  ? Colors.red
                                  : null,
                          size: 40.0,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (!EmpScreen.listFavorits.contains(EmpScreen.uid)) {
                          EmpScreen.listFavorits.add(EmpScreen.uid);
                          var collection = FirebaseFirestore.instance
                              .collection('Utilisateur');
                          //****** Fblast doc dir l id dyal li dakhl l app daba ****
                          collection
                              .doc(
                                  'IqxSEw6ZYnWkEiWAqgwiO2kTs3i2') // <-- Doc ID where data should be updated.
                              .update({
                            'favorits': EmpScreen.listFavorits.join(',')
                          });
                        } else {
                          EmpScreen.listFavorits.remove(EmpScreen.uid);
                          var collection = FirebaseFirestore.instance
                              .collection('Utilisateur');
                          //****** Fblast doc dir l id dyal li dakhl l app daba ****
                          collection
                              .doc(
                                  'IqxSEw6ZYnWkEiWAqgwiO2kTs3i2') // <-- Doc ID where data should be updated.
                              .update({
                            'favorits': EmpScreen.listFavorits.join(',')
                          });
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      minRadius: 35.0,
                      child: Icon(
                        Icons.call,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 20.0,
            color: Colors.blue,
          ),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Telephone',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    EmpScreen.nombre,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(
                  height: 2,
                ),
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    EmpScreen.email,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(
                  height: 2,
                ),
                ListTile(
                  title: Text(
                    'Adress',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    EmpScreen.adress,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(
                  height: 2,
                  color: Colors.black,
                ),
                ListTile(
                  title: Text(
                    'Price',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    EmpScreen.price.toString(),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
=======
>>>>>>> 98d7268348e8ddc507198a551f109461aba10ad4
