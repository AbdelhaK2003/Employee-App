import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/AddWork/AddWork.dart';
import 'package:login/screens/AddWork/UpdateDeleteWork.dart';

class EmpPage extends StatefulWidget {
  const EmpPage({Key? key}) : super(key: key);

  @override
  _EmpPageState createState() => _EmpPageState();
}

class _EmpPageState extends State<EmpPage> {
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('Utilisateur').snapshots();
  Map<String, dynamic>? dt;
  @override
  Widget build(BuildContext context) {
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
            var collection =
                FirebaseFirestore.instance.collection('Utilisateur');
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
            child: ListView(children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 110.0,
                //width: 100,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => Card(
                    child: Center(child: Text('Jobs')),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
                child: StreamBuilder<QuerySnapshot>(
              stream: users,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Something is wrong !',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      CircularProgressIndicator(),
                      Center(
                        heightFactor: 50,
                        widthFactor: 50,
                        child: Text(
                          'Loading',
                          style: TextStyle(
                            color: Color(0xEB1E1F69),
                          ),
                        ),
                      ),
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
                    return Container(
                      height: 120,
                      child: Card(
                        child: ListTile(
                          leading: SizedBox(
                            /* 
                            width: 100,
                            height: 200, */
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.amber,
                              backgroundImage: NetworkImage(
                                '${data.docs[index]['image']}',
                              ),
                            ),
                          ),
                          title: Text(
                              '${data.docs[index]['Lastname']}  ${data.docs[index]['Firstname']}'),
                          subtitle: Text(
                              'A sufficiently long subtitle warrants three lines.'),
                          trailing: Icon(Icons.favorite),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                );
              },
            )),
          ),
        ])));

    /* Scaffold(
      body: Center(child: Text('Emp page')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xEB1E1F69),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWork()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    ); */
  }

  _fetch() async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    var collection = FirebaseFirestore.instance.collection('Utilisateur');
    var docSnapshot = await collection.doc(user!.uid).get();
    dt = docSnapshot.data();
  }
}
/* Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: SizedBox(
                              width: 100,
                              height: 200,
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                backgroundImage: NetworkImage(
                                  '${data.docs[index]['image']}',
                                ),
                              ),
                            ),
                            title: Text(
                                '${data.docs[index]['Lastname']}  ${data.docs[index]['Firstname']}'),
                            subtitle: Text('${data.docs[index]['email']}'),
                          ),
                        ],
                      ),
                    ); */


