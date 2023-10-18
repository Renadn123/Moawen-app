import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moawen/add_ads.dart';
import 'package:moawen/model/status.dart';
import 'package:moawen/ads_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ADSRequest extends StatefulWidget {
  const ADSRequest({super.key});

  @override
  State<StatefulWidget> createState() => _ADSRequestState();
}

class _ADSRequestState extends State<ADSRequest> {
  static const String _title = 'Show Request';

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Ads');

  //String userId = CatchHelper.uid!;
  final _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getStreamByUserId(String userId) {
    return collection.where("userId", isEqualTo: userId).get().asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: const Center(
      //   //   child: Text(_title),
      //   // ),
      //   titleTextStyle: const TextStyle(
      //     color: Colors.black,
      //     fontSize: 26,
      //   ),
      //   backgroundColor: const Color(0XFF2F6968),
      //   elevation: 0,
      // ),
      body: Center(
        child: StreamBuilder(
            stream: getStreamByUserId(_auth.currentUser!.uid),
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
                                              ADSDetails(document: document)),
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
                                  onPressed: () {
                                    _payingAds(document);
                                  },
                                  child: Text(
                                    _getTextStatus(document),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const ADSAdd()));
        },
        child: const Icon(Icons.add),
      ),
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

  void _payingAds(QueryDocumentSnapshot<Object?> document) {
    if (document['status'] == StatusEnum.needPaying.name) {
      showSnackBar('Need Paying Ads', Colors.cyan);
      //Navigator.pushReplacement(context,
      // MaterialPageRoute(
      //     builder: (BuildContext context) {
      //       return const Payment();
      //     }));
    }
  }

  String _getTextStatus(QueryDocumentSnapshot<Object?> document) {
    if (document['status'] == StatusEnum.needPaying.name) {
      return "need Paying";
    }
    return document['status'];
  }

  void showSnackBar(String s, Color c) {
    final snackBar = SnackBar(
      content: Text(
        s,
        style: const TextStyle(fontSize: 20),
      ),
      backgroundColor: c,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
