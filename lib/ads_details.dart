import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ADSDetails extends StatefulWidget {
  const ADSDetails({super.key, required this.document});

  final DocumentSnapshot document;

  @override
  State<StatefulWidget> createState() => _ADSDetailsState();
}

class _ADSDetailsState extends State<ADSDetails> {
  static String _title = '';

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Ads');

  Stream<QuerySnapshot> getStreamByUserId(String userId) {
    return collection.where("userId", isEqualTo: userId).get().asStream();
  }

  @override
  void initState() {
    // TODO: implement initState
    _title = widget.document['description'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(_title),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 26,
        ),
        backgroundColor: const Color(0XFF2F6968),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(1),
              child: Image.network(
                widget.document['imageUrl'],
                height: 300,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12.0 , bottom:  12.0),
              child:  RichText(
                text:  TextSpan(
                    text: 'Description: ',
                    style: const TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.document['description'],

                          style: const TextStyle(
                              color: Colors.blueAccent, fontSize: 20))
                    ]),
              ),
            ),

            const SizedBox(
              height: 4.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12.0 , bottom:  12.0),
              child:  RichText(
                text:  TextSpan(
                    text: 'Period: ',
                    style: const TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.document['period'],
                          style: const TextStyle(
                              color: Colors.blueAccent, fontSize: 20))
                    ]),
              ),
            ),

            const SizedBox(
              height: 4.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12.0 , bottom:  12.0),
              child:  RichText(
                text:  TextSpan(
                    text: 'Status: ',
                    style: const TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.document['status'],
                          style: const TextStyle(
                              color: Colors.blueAccent, fontSize: 20))
                    ]),
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12.0 , bottom:  12.0),
              child:  RichText(
                text:  TextSpan(
                    text: 'Price: ',
                    style: const TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.document['price'].toString(),
                          style: const TextStyle(
                              color: Colors.blueAccent, fontSize: 20))
                    ]),
              ),
            ),
            /*
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Description: ${widget.document['description']}",
                  fillColor: Colors.blueGrey,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:"Period: ${widget.document['period']}",
                  fillColor: Colors.blueGrey,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Status: ${widget.document['status']}",
                  fillColor: Colors.blueGrey,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:"Price: ${widget.document['price']}",
                  fillColor: Colors.blueGrey,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ),


             */
          ],
        ),
      ),
    );
  }
}
