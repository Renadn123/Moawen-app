import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moawen/admin/ads_details_control.dart';

import '../model/status.dart';

class ADSControl extends StatefulWidget {
  const ADSControl({super.key});

  @override
  State<StatefulWidget> createState() => _ADSControlState();
}

class _ADSControlState extends State<ADSControl> {
  static const String _title = 'Admin Control';

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Ads');

  Stream<QuerySnapshot> getStreamByUserId() {
    return collection.where("status", isNotEqualTo: 'Done').get().asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(
      //     child: Text(_title),
      //   ),
      //   titleTextStyle: const TextStyle(
      //     color: Colors.black,
      //     fontSize: 26,
      //   ),
      //   backgroundColor: const Color(0XFF2F6968),
      //   elevation: 0,
      // ),
      body: Center(
        child: StreamBuilder(
            stream: getStreamByUserId(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print('Text Clicked');
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(builder: ((context) => ADSDetails(document: document)))
                                    //     );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ADSDetailControl(
                                                  document: document)),
                                    );
                                  },
                                  child: Text(
                                    document['description'],
                                    style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.blueGrey,
                                    side: BorderSide(
                                      color: _getColor(document),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    document['status'],
                                    style: const TextStyle(fontSize: 22),
                                  ), //   child: const Text("Cancel"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.amberAccent,
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => const ADSAdd()));
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  _getColor(QueryDocumentSnapshot<Object?> document) {
    if (document['status'] == StatusEnum.inProgress.name) {
      return Colors.black38;
    }

    if (document['status'] == StatusEnum.expired.name) {
      return Colors.amberAccent;
    }

    if (document['status'] == StatusEnum.needPaying.name) {
      return Colors.cyanAccent;
    }

    if (document['status'] == StatusEnum.accept.name) {
      return Colors.green;
    }

    if (document['status'] == StatusEnum.rejected.name) {
      return Colors.redAccent;
    }
    else {
      return Colors.blue;
    }
  }
}
