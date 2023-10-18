import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ProfilePage.dart';
import '../explore.dart';
import '../login_screen.dart';
import '../postmodel.dart';
import '../widget/flushbar_widget.dart';
import 'ads_control.dart';

class MainLayoutAdmin extends StatefulWidget {
  const MainLayoutAdmin({super.key});

  @override
  State<StatefulWidget> createState() => _MainLayoutAdminState();
}

class _MainLayoutAdminState extends State<MainLayoutAdmin> {
  static const String _title = 'Admin DashBoard';

  int index = 1;
  List<String> title = [
    'Home',
    'Explore',
    'Profile',
  ];

  List<PostModel> post = [];
  List<String> docsId = [];

  getdata() {
    // post.clear();
    FirebaseFirestore.instance
        .collection('Post')
        .orderBy('Time', descending: true)
        .snapshots()
        .listen((value) {
      FirebaseFirestore.instance.collection('users').get().then((valUser) {
        post = [];
        for (var element in value.docs) {
          for (var users in valUser.docs) {
            // print(users.data()['NID']);
            // print(element.data()['UserID']);
            if (users.data()['NID'] == element.data()['UserID']) {
              var map = element.data();
              map.addAll({
                'name': '${users.data()['fname']} ${users.data()['lname']}',
                'username': users.data()['username'].toString(),
                'imageUser':
                    'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg',
              });
              post.add(PostModel.json(map));
              docsId.add(element.id);
            }
          }
        }
        setState(() {});
      }).catchError((e) {
        flushbar(context, e.toString());
      });
      //setState(() {});
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 247, 246),
        appBar: AppBar(
          title: const Center(
            child: Text(_title),
          ),
          actions: [
            if (index == 2)
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 2) {
                    // Signout
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  }
                },
                itemBuilder: (BuildContext bc) {
                  return const [
                    // PopupMenuItem(
                    //   value: 1,
                    //   child: Text("Ads "),
                    // ),
                    PopupMenuItem(
                      value: 2,
                      child: Text("Logout"),
                    ),
                  ];
                },
              ),
            if (index == 1)
              DropdownButton<String>(
                underline: Container(),
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'account',
                    child: Text('Search by Account'),
                  ),
                  DropdownMenuItem(
                    value: 'post',
                    child: Text('Search by Post'),
                  ),
                ],
                onChanged: (value) {
                  if (value == 'post') {
                    // showSearch(
                    //     context: context, delegate: CustomSearchDelegate());
                  }
                  if (value == 'account') {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => search1()));
                  }
                },
              )
          ],
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 26,
          ),
          backgroundColor: const Color(0XFFffb3b3),
          elevation: 0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() {
            index = value;
          }),
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: const Color(0XFFff4d4d),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: 'Profile',
              backgroundColor: Colors.black,
            ),
          ],
        ),
        body: index == 0
            ? const ADSControl()
            : index == 1
                ? ExploreScreen(docsId: docsId, post: post)
                : const ProfilePage()
        //: Container(),
        );
  }
}
