import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moawen/model/status.dart';
class ADSDetailControl extends StatefulWidget{

  const ADSDetailControl({super.key, required this.document});
  final DocumentSnapshot document;

  @override
  State<StatefulWidget> createState() => _ADSDetailControlState();

}

class _ADSDetailControlState extends State<ADSDetailControl>{
  static String _title = '';

  final CollectionReference collection =  FirebaseFirestore.instance.collection('Ads');



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
        backgroundColor: const Color(0XFFffb3b3),
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
              height: 8.0,
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

            const SizedBox(
              height: 8.0,
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                    onPressed: () {
                      updateStatus (false);

                    },
                    child: const Text(
                      "Rejected",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {
                      updateStatus (true);
                    },
                    child: const Text(
                      "Accept",
                      style: TextStyle(fontSize: 22),
                    ), //   child: const Text("Cancel"),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  void updateStatus(bool bool) async {

    if (bool) {
      await collection.doc(widget.document.id).update({
        'status': StatusEnum.needPaying.name
      }).then((_) =>
          showSnackBar('Update Status Successfully', Colors.green)
      ).catchError((error) =>
          showSnackBar('Update Status failed: $error', Colors.red));
    }else{
      await collection.doc(widget.document.id).update({
        'status': StatusEnum.rejected.name
      }).then((_) =>
          showSnackBar('Update Status Successfully', Colors.green)
      ).catchError((error) =>
          showSnackBar('Update Status failed: $error', Colors.red));
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void showSnackBar(String s ,Color c) {
    final snackBar = SnackBar(
      content: Text(s, style: const TextStyle(fontSize: 20),),
      backgroundColor: c,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

}
