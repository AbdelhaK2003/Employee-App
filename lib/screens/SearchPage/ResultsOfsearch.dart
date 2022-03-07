import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; /* 
import 'package:provider/provider.dart'; */
import 'SearchFields.dart';

class ResultsOftsearch extends StatefulWidget {
  String City;
  String Job;
  late int min;
  late int max;

  ResultsOftsearch(
      {Key? key,
      required final this.City,
      required final this.Job,
      required final this.min,
      required final this.max})
      : super(key: key);

  @override
  _ResultsOftsearchState createState() => _ResultsOftsearchState();
}

class _ResultsOftsearchState extends State<ResultsOftsearch> {
  @override
  Widget build(BuildContext context) {
    String c = widget.City;
    String j = widget.Job;
    int mn = widget.min;
    int mx = widget.max;
    final Stream<QuerySnapshot> users = FirebaseFirestore.instance
        .collection('Utilisateur')
        .where("job", isEqualTo: j)
        .where("Adress", isEqualTo: c)
        .where("Price", isGreaterThanOrEqualTo: mn)
        .where("Price", isLessThanOrEqualTo: mx)
        .snapshots();
    print(c);
    print(j);
    print(mn);
    print(mx);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(Colors.white.value)),
        title: Text("Results"),
        backgroundColor: Color(0xEB1E1F69),
      ),
      body: Center(
        child: ListView(children: [
          Container(
              child: StreamBuilder<QuerySnapshot>(
            stream: users,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                    heightFactor: 35,
                    child: Text(
                      'Something went wrong !!',
                      style: TextStyle(color: Colors.red),
                    ));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    heightFactor: 50,
                    child: Row(
                      children: [
                        CircularProgressIndicator(),
                        Text(
                          'Waiting',
                          style: TextStyle(color: Color(0xEB1E1F69)),
                        ),
                      ],
                    ));
              }

              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 4, bottom: 4),
                    child: Container(
                      height: 120,
                      child: Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(2),
                          splashColor: Color.fromARGB(235, 133, 135, 226),
                          onTap: () {},
                          child: ListTile(
                            leading: Image.network(
                              '${data.docs[index]['image']}',
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                return loadingProgress == null
                                    ? child
                                    : CircularProgressIndicator();
                              },
                            ),
                            title: Text(
                                '${data.docs[index]['Lastname']}  ${data.docs[index]['Firstname']}'),
                            subtitle:
                                Text('${data.docs[index]['description']}'),
                            trailing: Icon(Icons.favorite),
                            isThreeLine: true,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )),
        ]),
      ),
    );
  }

  String getjob() {
    return widget.Job;
  }
}