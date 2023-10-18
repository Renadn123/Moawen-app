// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moawen/userProfile.dart';
import 'package:moawen/whitespace.dart';


class search1 extends StatefulWidget {
  const search1({Key? key}) : super(key: key);

  @override
  State<search1> createState() => _search1();
}

class _search1 extends State<search1> {
  String name = "";
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF2F6968),
            title: Card(
              color: Color(0xFF2F6968),
              child: TextField(
                inputFormatters: [
                  NoLeadingSpaceFormatter(),
                ],
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFF6FFFC),
                  ),
                  hintText: 'Search for person',
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFF6FFFC),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _controller.clear,
                icon: Icon(Icons.clear),
              ),
            ]

            // IconButton(
            //     icon: Icon(Icons.arrow_back, color: Color(0xFF2F6968)),
            //     onPressed: () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => ExploreScreen(
            //                     docsId: const [],
            //                     post: [],
            //                   )),
            //         )),
            ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                    //     Text(
                    //   "Not found any account by \n( $name  )",
                    //   style: TextStyle(
                    //       fontSize: 24,
                    //       fontStyle: FontStyle.italic,
                    //       color: Colors.black.withOpacity(0.9)),
                    //   textAlign: TextAlign.center,
                    // ),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      if (name.isEmpty) {
                        return ListTile(
                          title: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      if (data['fname']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['fname'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                        uid: data['NID'],
                                        name: data['fname'],
                                      ))),
                          //     onTap: () =>   Navigator.push(context,
                          // MaterialPageRoute(builder: (context) => Listview())),// حطيتها مبدئيا الى ان يظبط فيو بروفايل

                          subtitle: Text(
                            '@${data['username']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: //CircleAvatar(
                              //   backgroundImage: NetworkImage(data['image']),
                              // ),
                              Icon(
                            Icons.person_outline,
                            color: Colors.black,
                            size: 40,
                          ),
                        );
                      }
                      if (data['username']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['fname'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                        uid: data['NID'],
                                        name: data['fname'],
                                      ))),
                          subtitle: Text(
                            '@${data['username']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: //CircleAvatar(
                              //   backgroundImage: NetworkImage(data['image']),
                              // ),
                              Icon(
                            Icons.person_outline,
                            color: Colors.black,
                            size: 40,
                          ),
                        );
                      }
                      return Container();
                    });
          },
        ));
  }
}
