import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moawen/userProfile.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      //scaffoldBackgroundColor: , to change scaffold color
      appBarTheme: const AppBarTheme(
        //elevation: 0,
        //to change appbar
        color: Color(0XFF2F6968),

        //titleTextStyle: , to change title text
        //toolbarTextStyle: , to change toolbar text style
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Post').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");

          final results = snapshot.data?.docs.where(
              (element) => element['PostText'].toString().contains(query));
          print(results!.length.toString());

          return Container(
            margin: const EdgeInsets.all(4),
            child: results.isEmpty
                ? Center(
                    //child: CircularProgressIndicator(),
                    child: Text(
                      "Not found any post by keyword \n( $query  )",
                      style: TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          color: Colors.black.withOpacity(0.9)),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                    itemCount: results.length,
                    itemBuilder: (context, index) => InkWell(
                      // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) =>
                      //       ViewPost(data: results[index], docId: docsId[index]),
                      // )),
                      //
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            var map = (results.elementAt(index).data()
                                as Map<String, dynamic>);
                            if (snapshot.data != null) {
                              for (var element in snapshot.data!.docs) {
                                if ((map)['UserID'] == element.id) {
                                  map.addAll({
                                    'name':
                                        '${(element.data() as Map)['fname']} ${(element.data() as Map)['lname']}',
                                    'username':
                                        (element.data() as Map)['username']
                                            .toString(),
                                    'imageUser':
                                        'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg',
                                    'NID': (element.data() as Map)['NID']
                                        .toString(),
                                  });
                                }
                              }
                            }
                            return Column(children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, right: 10, bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color(0XFFF6FFFC)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) => UserProfile(
                                                      uid:
                                                          '${map['NID'] ?? "ql5cw4G95DSkUZmdkgPYipm0j0I3"}',
                                                      name:
                                                          '${map['name'] ?? "monerah"}'),
                                                ));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 4),
                                                ),
                                                child: const Icon(
                                                  Icons.person_outline,
                                                  color: Colors.black,
                                                  size: 40,
                                                ),
                                              )),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${map['name'] ?? "No name"}'),
                                            Text(
                                              '@${map['username'] ?? "No name"}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${map['PostText'] ?? "No Text"}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(TimeOfDay.fromDateTime(
                                                    DateTime.parse(
                                                        '${map['Time'] ?? "No name"}'))
                                                .format(context)
                                                .toString()),
                                            const SizedBox(width: 5.0),
                                            Text(DateFormat.yMMMMd()
                                                .format(DateTime.parse(
                                                    '${map['Time'] ?? "No name"}'))
                                                .toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: InkWell(
                                                    child: const Icon(Icons
                                                        .mode_comment_outlined),
                                                    onTap: () {
                                                      // Navigator.of(context)
                                                      //     .push(MaterialPageRoute(
                                                      //   builder: (context) => ViewPost(
                                                      //       data: widget.post[index],
                                                      //       docId: widget.docsId[index]),
                                                      // ));
                                                    },
                                                  ))), //addcommentIcon
                                          Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: InkWell(
                                                    child: const Icon(
                                                        Icons.favorite),
                                                    onTap: () {},
                                                  ))), //likeIcon
                                          //if (CatchHelper.uid == widget.post[index].userid)
                                          //deletIcon
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                          }),
                    ),
                  ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
// This method is called everytime the search term changes.

    return const Center(
      child: Text('Search by post title'),
    );
  }
}
